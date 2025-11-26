import db from '../models/index.js';
import { CustomError } from '../utils/CustomError.js';
import { HeroineErrorCode } from '../errors/heroineErrorCode.js';

const { Heroine, HeroineImage, HeroineLike, Progress } = db;

// 히로인 전체 목록
export const getHeroines = async () => {
    const heroines = await Heroine.findAll({
        include: [
            {
                model: HeroineImage,
                as: 'images',
                attributes: ['id', 'description', 'imageUrl'],
            },
        ],
        order: [['id', 'ASC']],
    });

    return heroines;
};

// 히로인 상세
export const getHeroineById = async (heroineId) => {
    const heroine = await Heroine.findByPk(heroineId, {
        include: [
            {
                model: HeroineImage,
                as: 'images',
                attributes: ['id', 'description', 'imageUrl'],
            },
        ],
    });

    if (!heroine) {
        throw CustomError.from(HeroineErrorCode.NOT_FOUND);
    }

    return heroine;
};

// 현재 슬롯 기준 호감도 게이지 표시용
export const getHeroineLikesBySlot = async (userId, slot) => {
    const progress = await Progress.findOne({
        where: { userId, slot },
    });

    if (!progress) {
        // 세이브가 없으면 빈 배열 리턴
        return [];
    }

    const likes = await HeroineLike.findAll({
        where: { progressId: progress.id },
        include: [
            {
                model: Heroine,
                as: 'heroine',
                attributes: ['id', 'name', 'language'],
            },
        ],
    });

    return likes.map((l) => ({
        heroineId: l.heroineId,
        heroineName: l.heroine?.name ?? null,
        language: l.heroine?.language ?? null,
        likeValue: l.likeValue,
    }));
};