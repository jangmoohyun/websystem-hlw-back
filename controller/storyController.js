import * as storyService from "../service/storyService.js";

// 스토리 목록
export const getStories = async (req, res) => {
  const stories = await storyService.getStories();
  res.json({
    success: true,
    data: stories,
  });
};

// 스토리 + 히로인 이미지
export const getStoryById = async (req, res) => {
    const storyId = Number(req.params.id);
    const story = await storyService.getStoryWithHeroines(storyId);

    res.json({
        success: true,
        data: story,
    });
};

// 문제 목록: 해당 스토리와 연결된 문제들을 반환합니다 (관리/프론트에서 사용)
export const getProblemsByStory = async (req, res) => {
  const storyId = Number(req.params.id);
  // Lazy import of db to avoid circular deps
  const db = await import("../models/index.js");
  const { Problem, Testcase } = db.default;

  const problems = await Problem.findAll({
    where: { story_id: storyId },
    include: [
      {
        model: Testcase,
        as: "testcases",
        where: { is_public: 1 },
        required: false,
      },
    ],
  });

  return res.json({ success: true, data: problems });
};