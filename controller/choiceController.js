import db from "../models/index.js";
import * as progressService from "../service/progressService.js";

// POST /choices/select 핸들러
// 요청 바디 형식: { storyId, currentLineIndex, choice: { targetIndex, endIndex, heroineName, affinityDelta, branchStoryId, text } }
// 동작 설명:
// 1) 요청에 인증된 사용자 정보(req.user.id)가 있으면 해당 사용자로 처리합니다. 인증 정보가 없으면 body.userId 또는 시드된 테스트 계정으로 대체(개발 환경용).
// 2) choice에 heroineName과 affinityDelta가 있으면 progressService.applyAffinityChange를 호출해 호감도를 갱신합니다.
// 3) choice에 branchStoryId가 있으면 해당 story로 progress.storyId를 변경해 서버 측에서 스토리 분기를 처리하도록 합니다.
// 4) 최종적으로 클라이언트에게 action과 네비게이션 정보를 반환합니다.

export const selectChoice = async (req, res) => {
  // 인증된 사용자 우선 사용. 인증 정보가 없고 개발 모드인 경우 시드된 테스트 사용자로 대체합니다.
  let userId = req.user?.id ?? req.body.userId;
  if (!userId) {
    // 개발 편의용: 시드로 생성된 테스트 사용자가 있으면 그 사용자를 사용합니다.
    // 프로덕션 환경에서는 인증을 필수화하고 이 대체 로직을 제거하세요.
    const u = await db.User.findOne({
      where: { email: "branch_tester@example.com" },
    });
    if (u) userId = u.id;
  }
  if (!userId) {
    return res.status(400).json({ success: false, message: "userId required" });
  }

  const { storyId, currentLineIndex, choice } = req.body;
  if (!choice) {
    return res.status(400).json({ success: false, message: "choice required" });
  }

  try {
    // 1) apply affinity if provided
    if (choice.heroineName && typeof choice.affinityDelta === "number") {
      await progressService.applyAffinityChange(
        userId,
        storyId,
        choice.heroineName,
        choice.affinityDelta
      );
    }

    // 2) branch to another story if requested
    if (choice.branchStoryId) {
      // ensure progress exists and update storyId
      const progress = await progressService.getOrCreateProgress(
        userId,
        storyId
      );
      progress.storyId = choice.branchStoryId;
      progress.lineIndex = 0;
      await progress.save();

      return res.json({
        success: true,
        result: {
          action: "branch",
          storyId: choice.branchStoryId,
          lineIndex: 0,
        },
      });
    }

    // 3) otherwise, respond with navigation hints (frontend에서 targetIndex를 사용해 위치를 해석)
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
