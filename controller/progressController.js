import * as progressService from "../service/progressService.js";

// GET /progress/saves
export const getSaves = async (req, res) => {
  const userId = req.user.id;
  const data = await progressService.getSaves(userId);

  res.json({
    success: true,
    data,
  });
};

// PUT /progress/save
export const saveGame = async (req, res) => {
  const userId = req.user.id;
  const { slot, storyId, lineIndex, heroineLikes } = req.body;

  const saved = await progressService.saveGame(userId, {
    slot,
    storyId,
    lineIndex,
    heroineLikes,
  });

  res.status(201).json({
    success: true,
    data: saved,
  });
};

// GET /progress/save?slot=1
export const loadGame = async (req, res) => {
  const userId = req.user.id;
  const slot = Number(req.query.slot);

  const saveData = await progressService.loadGame(userId, { slot });

  res.json({
    success: true,
    data: saveData,
  });
};

// PATCH /choice
export const applyChoice = async (req, res) => {
  const userId = req.user.id;
  const { slot, storyId, currentIndex, choiceIndex } = req.body;

  const result = await progressService.applyChoice(userId, {
    slot,
    storyId,
    currentIndex,
    choiceIndex,
  });

  res.json({ success: true, data: result });
};

// POST /progress/jump-affinity
export const jumpAffinity = async (req, res) => {
  const userId = req.user.id;
  const { slot } = req.body || {};

  const result = await progressService.jumpToAffinityStory(userId, { slot });

  res.json({ success: true, data: result });
};
