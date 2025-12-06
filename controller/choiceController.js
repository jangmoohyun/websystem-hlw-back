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
  // Debug: log incoming payload
  try {
    console.log("[selectChoice] incoming body:", JSON.stringify(req.body));
  } catch (e) {
    console.log("[selectChoice] incoming body (non-serializable)");
  }
  // 인증된 사용자 우선 사용. 인증 정보가 없고 개발 모드인 경우 시드된 테스트 사용자로 대체합니다.
  let userId = req.user?.id ?? req.body.userId;

  // Development fallback: if provided userId doesn't exist (or absent),
  // use or create a development user (by email) and use its UUID.
  const devEmail = process.env.DEV_USER_EMAIL || "dev_user@example.com";
  if (userId) {
    const u = await db.User.findByPk(userId);
    if (!u) {
      // requested userId not found — fall back to dev user
      let dev = await db.User.findOne({ where: { email: devEmail } });
      if (!dev) {
        dev = await db.User.create({
          email: devEmail,
          password: "devpassword",
          nickname: "dev",
        });
      }
      userId = dev.id;
    }
  } else {
    // no userId provided: ensure dev user exists and use it
    let dev = await db.User.findOne({ where: { email: devEmail } });
    if (!dev) {
      dev = await db.User.create({
        email: devEmail,
        password: "devpassword",
        nickname: "dev",
      });
    }
    userId = dev.id;
  }

  const { storyId, currentLineIndex, choice, choiceIndex } = req.body;
  if (!choice) {
    return res.status(400).json({ success: false, message: "choice required" });
  }

  try {
    // Prefer canonical choice stored in story.script if currentLineIndex+choiceIndex provided
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

    // 1) apply affinity if provided (from canonical choice)
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

    // 2) branch to another story if requested
    const branchId = canonicalChoice?.branchStoryId ?? null;
    if (branchId) {
      // validate branch story exists to avoid FK violations
      const branchStory = await db.Story.findByPk(branchId);
      if (!branchStory) {
        return res
          .status(400)
          .json({ success: false, message: "branchStoryId does not exist" });
      }
      // ensure progress exists and update storyId
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
