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
        where: { is_public: 1 },
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
// - 모든 테스트가 일치하면 pass로 판정하고, 선택지에 설정된 효과(effects) 중 affinity를 적용합니다.
// - 결과는 { passed, testResults } 형태로 반환합니다.
export const submitCode = async (req, res) => {
  const storyId = Number(req.params.storyId);
  const { userId, nodeIndex, choiceId, problemId, sourceCode, languageId } =
    req.body;
  if (!userId || !sourceCode || !languageId || !problemId) {
    return res.status(400).json({
      success: false,
      error: "userId, sourceCode, languageId, problemId required",
    });
  }

  // 스토리 존재 여부 확인
  const story = await Story.findByPk(storyId);
  if (!story)
    return res
      .status(404)
      .json({ success: false, error: "스토리가 존재하지 않습니다" });

  // 문제와 모든 테스트케이스 로드
  const problem = await JudgeProblem.findByPk(problemId, {
    include: [{ model: JudgeTestcase, as: "testcases" }],
  });
  if (!problem)
    return res.status(404).json({ success: false, error: "problem not found" });

  // 테스트케이스 정렬 및 추출(사용자 요구대로 보통 5개가 들어있음)
  const tcs = (problem.testcases || [])
    .sort((a, b) => (a.order || 0) - (b.order || 0))
    .map((tc) => ({ input: tc.input ?? "", expected: tc.expected ?? "" }));

  // Judge0에 테스트 실행 요청
  const results = await runMultipleTestsBase64(sourceCode, languageId, tcs);

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
      ok,
    };
  });

  // 만약 통과했다면(그리고 choiceId가 주어졌다면) 해당 choice의 effects 중 affinity를 적용
  if (passed && choiceId !== undefined && choiceId !== null) {
    // story.script JSON에서 노드/선택지를 찾아 effects를 적용 (best-effort)
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
    const choice = node?.choices?.find(
      (c) => String(c.id) === String(choiceId)
    );
    if (choice && Array.isArray(choice.effects)) {
      for (const eff of choice.effects) {
        if (eff.type === "affinity") {
          // progressService의 헬퍼로 호감도 적용
          await progressService.applyAffinityChange(
            userId,
            storyId,
            eff.heroine,
            eff.delta
          );
        }
      }
    }
  }

  // 결과 반환
  return res.json({ success: true, passed, testResults });
};
