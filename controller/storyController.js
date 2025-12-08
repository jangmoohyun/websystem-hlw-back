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
