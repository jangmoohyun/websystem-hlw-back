import * as storyService from '../service/storyService.js';

// 스토리 목록
export const getStories = async (req, res) => {
    const stories = await storyService.getStories();
    res.json({
        success: true,
        data: stories,
    });
};

// 스토리 상세 + 스크립트
export const getStoryById = async (req, res) => {
    const storyId = Number(req.params.id);
    const story = await storyService.getStoryById(storyId);
    res.json({
        success: true,
        data: story,
    });
};