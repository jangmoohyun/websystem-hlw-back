import db from '../models/index.js';
import { CustomError } from '../utils/customError.js';
import { StoryErrorCode } from '../errors/storyErrorCode.js';

const { Story, Script } = db;

// 스토리 목록
export const getStories = async () => {
    const stories = await Story.findAll({
        attributes: ['id', 'title', 'content', 'image'],
        order: [['id', 'ASC']],
    });

    return stories;
};

// 스토리 상세 + 스크립트
export const getStoryById = async (storyId) => {
    const story = await Story.findByPk(storyId, {
        attributes: ['id', 'title', 'content', 'image'],
        include: [
            {
                model: Script,
                as: 'script',
            },
        ],
    });

    if (!story) {
        throw CustomError.from(StoryErrorCode.NOT_FOUND);
    }

    return story;
};