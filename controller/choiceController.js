import db from "../models/index.js";
import * as progressService from "../service/progressService.js";
import { getScriptNode } from "../service/scriptService.js";

// POST /choices/select 핸들러
// 요청 바디 형식: { storyId, currentLineIndex, choice: { targetIndex, endIndex, heroineName, affinityDelta, branchStoryId, text } }
// 동작 설명:
// 1) 요청에 인증된 사용자 정보(req.user.id)가 있으면 해당 사용자로 처리합니다. 인증 정보가 없으면 body.userId 또는 시드된 테스트 계정으로 대체(개발 환경용).
// 2) choice에 heroineName과 affinityDelta가 있으면 progressService.applyAffinityChange를 호출해 호감도를 갱신합니다.
// 3) choice에 branchStoryId가 있으면 해당 story로 progress.storyId를 변경해 서버 측에서 스토리 분기를 처리하도록 합니다.
// 4) 최종적으로 클라이언트에게 action과 네비게이션 정보를 반환합니다.

export const selectChoice = async (req, res) => {
  // authMiddleware를 통해 req.user가 설정됨
  const userId = req.user?.id;
  if (!userId) {
    return res
      .status(401)
      .json({ success: false, message: "Authentication required" });
  }

  const { storyId, currentLineIndex, choice, choiceIndex } = req.body;
  if (!choice) {
    return res.status(400).json({ success: false, message: "choice required" });
  }

  try {
    // 스크립트에 저장된 canonical choice가 있으면 그것을 우선 사용합니다 (currentLineIndex+choiceIndex가 제공된 경우)
    let canonicalChoice = choice;
    if (
      typeof currentLineIndex === "number" &&
      typeof choiceIndex === "number"
    ) {
      const node = await getScriptNode(storyId, currentLineIndex);
      if (node && node.type === "choice" && Array.isArray(node.choices)) {
        const c = node.choices[choiceIndex];
        if (c) canonicalChoice = c;
      }
    }

    // 1) 히로인 호감도 적용: canonical choice에 호감도 정보가 있으면 적용
    if (
      canonicalChoice?.heroineName &&
      typeof canonicalChoice?.affinityDelta === "number"
    ) {
      await progressService.applyAffinityChange(
        userId,
        storyId,
        canonicalChoice.heroineName,
        canonicalChoice.affinityDelta
      );
    }

    // 2) 분기 처리: canonical choice에 branchStoryId가 있으면 다른 스토리로 분기
    const branchId = canonicalChoice?.branchStoryId ?? null;
    if (branchId) {
      // 분기 대상 스토리가 존재하는지 확인하여 FK 오류를 방지
      const branchStory = await db.Story.findByPk(branchId);
      if (!branchStory) {
        return res
          .status(400)
          .json({ success: false, message: "branchStoryId does not exist" });
      }
      // progress 레코드가 존재하도록 보장한 뒤 storyId를 분기 대상으로 변경
      const progress = await progressService.getOrCreateProgress(
        userId,
        storyId
      );
      progress.storyId = branchId;
      progress.lineIndex = 0;
      await progress.save();

      return res.json({
        success: true,
        result: {
          action: "branch",
          storyId: branchId,
          lineIndex: 0,
        },
      });
    }

    // 3) 그 외에는 네비게이션 힌트를 응답합니다 (프론트는 targetIndex로 위치를 해석)
    return res.json({
      success: true,
      result: {
        action: "navigate",
        targetIndex: choice.targetIndex ?? null,
        endIndex: choice.endIndex ?? null,
      },
    });
  } catch (err) {
    console.error("selectChoice error", err);
    return res
      .status(500)
      .json({ success: false, message: err.message || "internal error" });
  }
};
