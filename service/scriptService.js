import db from "../models/index.js";
const { Script } = db;

// line에서 특정 index를 가진 줄 찾기
export const getScriptNode = async (storyId, index) => {
  const script = await Script.findOne({
    // `Script` table uses `story_id` as the foreign key field
    where: { story_id: storyId },
    attributes: ["line"],
  });

  if (!script) return null;

  const nodes = script.line; // JSON 배열
  return nodes.find((node) => node.index === index) ?? null;
};
