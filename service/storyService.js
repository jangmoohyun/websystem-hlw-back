import db from '../models/index.js';
import { CustomError } from '../utils/customError.js';
import { StoryErrorCode } from '../errors/storyErrorCode.js';

const { Story, Script } = db;

// 스토리 목록
export const getStories = async () => {
    const stories = await Story.findAll({
        attributes: ['id', 'storyCode', 'title', 'content', 'image', 'nextStoryId'],
        order: [['storyCode', 'ASC']],
    });

    return stories;
};

// 스토리 + 히로인 이미지 가져오기
export const getStoryWithHeroines = async (storyId) => {
    const story = await Story.findByPk(storyId, {
        include: [
            {
                model: Script,
                as: 'script',
            },
            {
                model: Heroine,
                as: 'heroines',
                attributes: ['id', 'name', 'language'],
                include: [
                    {
                        model: HeroineImage,
                        as: 'images',
                        attributes: ['id', 'description', 'imageUrl'],
                    },
                ],
            },
        ],
    });

    if (!story) throw CustomError.from(StoryErrorCode.NOT_FOUND);
    return story;
};