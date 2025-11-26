import * as heroineService from '../service/heroineService.js';

// GET /heroines
export const getHeroines = async (req, res) => {
    const heroines = await heroineService.getHeroines();
    res.json({
        success: true,
        data: heroines,
    });
};

// GET /heroines/:id
export const getHeroineById = async (req, res) => {
    const heroineId = Number(req.params.id);
    const heroine = await heroineService.getHeroineById(heroineId);

    res.json({
        success: true,
        data: heroine,
    });
};

// GET /heroines/likes?slot=1
export const getHeroineLikesBySlot = async (req, res) => {
    const userId = req.user.id;
    const slot = Number(req.query.slot);

    const likes = await heroineService.getHeroineLikesBySlot(userId, slot);

    res.json({
        success: true,
        data: likes,
    });
};