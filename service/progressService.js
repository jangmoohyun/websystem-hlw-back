import db from '../models/index.js';
import { CustomError } from '../utils/CustomError.js';
import { ProgressErrorCode } from '../errors/progressErrorCode.js';
import { StoryErrorCode } from '../errors/storyErrorCode.js';

const { Progress, Story, HeroineLike, Heroine } = db;

// 전체 게임 세이브 슬롯 목록 (1~5)
export const getSaves = async (userId) => {
    const saves = await Progress.findAll({
        where: { userId },
        include: [
            {
                model: Story,
                as: 'story',
                attributes: ['id', 'title', 'image'],
            },
            {
                model: HeroineLike,
                as: 'heroineLikes',
                include: [
                    {
                        model: Heroine,
                        as: 'heroine',
                        attributes: ['id', 'name'],
                    },
                ],
            },
        ],
        order: [['slot', 'ASC']],
    });

    // 1~5 슬롯 기준으로 정리
    const slotMap = new Map();
    saves.forEach((s) => {
        slotMap.set(s.slot, s);
    });

    const result = [];
    for (let slot = 1; slot <= 5; slot++) {
        const s = slotMap.get(slot);
        if (!s) {
            result.push({
                slot,
                isEmpty: true,
                story: null,
                lineIndex: null,
                heroineLikes: [],
                updatedAt: null,
            });
        } else {
            result.push({
                slot,
                isEmpty: false,
                story: {
                    id: s.storyId,
                    title: s.story?.title ?? null,
                    image: s.story?.image ?? null,
                },
                lineIndex: s.lineIndex,
                heroineLikes: s.heroineLikes.map((hl) => ({
                    heroineId: hl.heroineId,
                    heroineName: hl.heroine?.name ?? null,
                    likeValue: hl.likeValue,
                })),
                updatedAt: s.updatedAt,
            });
        }
    }

    return result;
};

// 세이브 저장/덮어쓰기
export const saveGame = async (userId, { slot, storyId, lineIndex, heroineLikes }) => {
    if (!slot || slot < 1 || slot > 5) {
        throw CustomError.from(ProgressErrorCode.INVALID_SLOT);
    }

    const story = await Story.findByPk(storyId);
    if (!story) {
        throw CustomError.from(StoryErrorCode.NOT_FOUND);
    }

    const [progress, created] = await Progress.findOrCreate({
        where: { userId, slot },
        defaults: {
            storyId,
            lineIndex,
        },
    });

    if (!created) {
        progress.storyId = storyId;
        progress.lineIndex = lineIndex;
        await progress.save();
    }

    if (Array.isArray(heroineLikes)) {
        for (const hl of heroineLikes) {
            const { heroineId, likeValue } = hl;
            if (!heroineId) continue;

            const [like, likeCreated] = await HeroineLike.findOrCreate({
                where: {
                    progressId: progress.id,
                    heroineId,
                },
                defaults: {
                    likeValue: likeValue ?? 0,
                },
            });

            if (!likeCreated) {
                like.likeValue = likeValue ?? like.likeValue;
                await like.save();
            }
        }
    }

    return progress;
};

// 세이브 불러오기 (슬롯 기준)
export const loadGame = async (userId, { slot }) => {
    if (!slot || slot < 1 || slot > 5) {
        throw CustomError.from(ProgressErrorCode.INVALID_SLOT);
    }

    const progress = await Progress.findOne({
        where: { userId, slot },
        include: [
            {
                model: HeroineLike,
                as: 'heroineLikes',
                include: [
                    {
                        model: Heroine,
                        as: 'heroine',
                        attributes: ['id', 'name'],
                    },
                ],
            },
        ],
    });

    if (!progress) {
        throw CustomError.from(ProgressErrorCode.NOT_FOUND);
    }

    return {
        storyId: progress.storyId,
        slot: progress.slot,
        lineIndex: progress.lineIndex,
        heroineLikes: progress.heroineLikes.map((hl) => ({
            heroineId: hl.heroineId,
            heroineName: hl.heroine?.name ?? null,
            likeValue: hl.likeValue,
        })),
    };
};