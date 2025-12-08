import db from "../models/index.js";
import { CustomError } from "../utils/customError.js";
import { StoryErrorCode } from "../errors/storyErrorCode.js";

const { Story, Script, Heroine, HeroineImage } = db;

// 스토리 목록
export const getStories = async () => {
  const stories = await Story.findAll({
    attributes: ["id", "storyCode", "title", "content", "image", "nextStoryId"],
    order: [["storyCode", "ASC"]],
  });

  return stories;
};

// 스토리 + 히로인 이미지 가져오기
export const getStoryWithHeroines = async (storyId) => {
  const db = await import("../models/index.js");
  const { Problem, Testcase } = db.default;

  const story = await Story.findByPk(storyId, {
    include: [
      {
        model: Script,
        as: "script",
      },
      {
        model: Heroine,
        as: "heroines",
        attributes: ["id", "name", "language"],
        include: [
          {
            model: HeroineImage,
            as: "images",
            attributes: ["id", "description", "imageUrl"],
          },
        ],
      },
      // include problems associated with the story (with public testcases only)
      {
        model: Problem,
        as: "problems",
        required: false,
        include: [
          {
            model: Testcase,
            as: "testcases",
            where: { isPublic: true },
            required: false,
          },
        ],
      },
    ],
  });

  if (!story) throw CustomError.from(StoryErrorCode.NOT_FOUND);
  // 히로인 별 languageId 매핑
  const plain = story.toJSON ? story.toJSON() : story;

  const LANGUAGE_NAME_TO_ID = {
    c: 50,
    python: 71,
    java: 91,
  };

  function mapLangToId(lang) {
    if (!lang) return null;
    const s = String(lang).toLowerCase().trim();
    if (LANGUAGE_NAME_TO_ID[s]) return LANGUAGE_NAME_TO_ID[s];
    if (s.includes("python")) return 71;
    if (s.includes("java")) return 91;
    if (s === "c" || s.includes("c")) return 50;
    return null;
  }

  if (Array.isArray(plain.heroines)) {
    plain.heroines = plain.heroines.map((h) => {
      const copy = { ...h };
      copy.languageId = mapLangToId(h.language) ?? null;
      return copy;
    });
  }

  return plain;
};
