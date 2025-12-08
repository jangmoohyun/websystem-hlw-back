import db from "../models/index.js";
import {
  runMultipleTestsBase64,
  normalizeOutput,
} from "../utils/judge0Client.js";
import * as progressService from "../service/progressService.js";

const { Problem, Testcase, Story } = db;

// 문제 조회 엔드포인트
// GET /judge/problems/:id
// 공개(public) 테스트케이스만 함께 반환합니다(프론트에 문제를 보여줄 때 사용).
export const getProblem = async (req, res) => {
  const id = Number(req.params.id);
  const problem = await Problem.findByPk(id, {
    include: [
      {
        model: Testcase,
        as: "testcases",
        where: { isPublic: true },
        required: false,
      },
    ],
  });
  if (!problem)
    return res
      .status(404)
      .json({ success: false, error: "문제가 존재하지 않습니다" });
  return res.json({ success: true, data: problem });
};

// 코드 제출 처리 엔드포인트
// POST /:storyId/submit-code
// body: { userId, nodeIndex, choiceId, problemId, sourceCode, languageId }
// - 프론트에서 제출한 코드를 Judge0로 보내고 각 테스트케이스의 출력과 expected를 비교합니다.
// - 모든 테스트가 일치하면 pass로 판정하고, 문제 노드에 정의된 effects(node.meta.effects)를 적용합니다.
// - 결과는 { passed, testResults, appliedAffinities } 형태로 반환합니다.
export const submitCode = async (req, res) => {
  const storyId = Number(req.params.storyId);

  // authMiddleware를 통해 req.user가 설정됨
  const userId = req.user?.id;
  if (!userId) {
    return res.status(401).json({
      success: false,
      error: "Authentication required",
    });
  }

  const { nodeIndex, choiceId, problemId, sourceCode, languageId } = req.body;
  if (!sourceCode || !languageId || !problemId) {
    return res.status(400).json({
      success: false,
      error: "sourceCode, languageId, problemId required",
    });
  }

  // 스토리 존재 여부 확인 (heroines와 script 포함)
  const story = await Story.findByPk(storyId, {
    include: [
      { model: db.Heroine, as: "heroines", required: false },
      { model: db.Script, as: "script", required: false },
    ],
  });
  if (!story)
    return res
      .status(404)
      .json({ success: false, error: "스토리가 존재하지 않습니다" });

  let finalLanguageId = languageId;
  if (!finalLanguageId) {
    const heroines = story.heroines || [];
    if (heroines.length > 0) {
      const heroineLang = (heroines[0].language || "").toString().toLowerCase();
      const LANGUAGE_NAME_TO_ID = {
        c: 50,
        python: 71,
        java: 91,
      };

      finalLanguageId = LANGUAGE_NAME_TO_ID[heroineLang];
      if (!finalLanguageId) {
        if (heroineLang.includes("python")) finalLanguageId = 71;
        else if (heroineLang.includes("java")) finalLanguageId = 91;
        else if (heroineLang === "c") finalLanguageId = 50;
      }
    }
  }

  if (!finalLanguageId) {
    return res.status(400).json({
      success: false,
      error: "languageId를 찾을 수 없습니다",
    });
  }

  // 문제와 모든 테스트케이스 로드
  const problem = await Problem.findByPk(problemId, {
    include: [{ model: Testcase, as: "testcases" }],
  });
  if (!problem)
    return res
      .status(404)
      .json({ success: false, error: "문제를 찾을 수 없습니다" });

  // 테스트케이스 정렬 및 추출(사용자 요구대로 보통 5개가 들어있음)
  const tcs = (problem.testcases || [])
    .sort((a, b) => (a.order || 0) - (b.order || 0))
    .map((tc) => ({ input: tc.input ?? "", expected: tc.expected ?? "" }));

  // Judge0에 테스트 실행 요청 (derived language id 사용)
  const results = await runMultipleTestsBase64(
    sourceCode,
    finalLanguageId,
    tcs
  );

  // 정규화(normalize) 후 모든 케이스가 일치하는지 판정
  let passed = true;
  const testResults = results.map((r, i) => {
    const out = normalizeOutput(r.stdout);
    const exp = normalizeOutput(tcs[i].expected);
    const ok = out === exp;
    if (!ok) passed = false;
    return {
      input: tcs[i].input,
      expected: tcs[i].expected,
      stdout: r.stdout,
      stderr: r.stderr,
      compile: r.compile,
      status: r.status ?? null,
      time: r.time ?? null,
      memory: r.memory ?? null,
      ok,
    };
  });

  // 통과 시 문제 노드(meta)에 명시된 affinity 효과 적용
  const appliedAffinities = [];
  if (passed) {
    let nodes = story.script?.line ?? story.script ?? [];
    if (typeof nodes === "string") {
      try {
        nodes = JSON.parse(nodes);
      } catch (e) {
        nodes = [];
      }
    }
    const node = (nodes || []).find(
      (n) => Number(n.index) === Number(nodeIndex)
    );
    const codeEffects = node?.meta?.effects ?? [];
    if (Array.isArray(codeEffects)) {
      for (const eff of codeEffects) {
        if (eff.type === "affinity") {
          const like = await progressService.applyAffinityChange(
            userId,
            storyId,
            eff.heroine,
            eff.delta
          );
          appliedAffinities.push({
            heroine: eff.heroine,
            delta: eff.delta,
            likeValue: like?.likeValue ?? null,
          });
        }
      }
    }
    // 호감도 15 증가
    if (appliedAffinities.length === 0) {
      const defaultHeroine =
        node?.speaker || (story.heroines && story.heroines[0]?.name) || null;
      if (defaultHeroine) {
        try {
          const like = await progressService.applyAffinityChange(
            userId,
            storyId,
            defaultHeroine,
            15
          );
          appliedAffinities.push({
            heroine: defaultHeroine,
            delta: 15,
            likeValue: like?.likeValue ?? null,
          });
        } catch (e) {}
      }
    }
  }

  // 결과 저장: 사용자 제출 코드 기록(UserCode)에 저장 (실패해도 진행)
  try {
    const stdoutCombined = (testResults || [])
      .map((t) => t.stdout ?? "")
      .join("\n---\n");
    await db.UserCode.create({
      userId,
      problemId,
      code: sourceCode,
      isPass: Boolean(passed),
      stdout: stdoutCombined,
      content: stdoutCombined,
    });
  } catch (e) {
    console.warn("Failed to save UserCode", e);
  }

  return res.json({ success: true, passed, testResults, appliedAffinities });
};
