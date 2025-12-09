import { getScriptNode } from "./scriptService.js";
import db from "../models/index.js";
import { CustomError } from "../utils/customError.js";
import { ProgressErrorCode } from "../errors/progressErrorCode.js";
import { StoryErrorCode } from "../errors/storyErrorCode.js";

const { Progress, Story, Script, HeroineLike, Heroine } = db;

// 전체 게임 세이브 슬롯 목록 (1~5)
export const getSaves = async (userId) => {
  const saves = await Progress.findAll({
    where: { userId },
    include: [
      {
        model: Story,
        as: "story",
        attributes: ["id", "title", "image"],
      },
      {
        model: HeroineLike,
        as: "heroineLikes",
        include: [
          {
            model: Heroine,
            as: "heroine",
            attributes: ["id", "name"],
          },
        ],
      },
    ],
    order: [["slot", "ASC"]],
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
export const saveGame = async (
  userId,
  { slot, storyId, lineIndex, heroineLikes }
) => {
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
        as: "heroineLikes",
        include: [
          {
            model: Heroine,
            as: "heroine",
            attributes: ["id", "name"],
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

// 선택지 적용 + 호감도/진행도 업데이트
export const applyChoice = async (
  userId,
  { slot, storyId, currentIndex, choiceIndex }
) => {
  // 1) 세이브 슬롯 찾기
  let progress;
  if (typeof slot === "number") {
    // slot이 명시되어 있으면 해당 슬롯으로 조회
    progress = await Progress.findOne({ where: { userId, slot } });
    if (!progress || progress.storyId !== storyId) {
      throw CustomError.from(ProgressErrorCode.NOT_FOUND);
    }
  } else {
    // slot이 없으면 해당 userId+storyId에 대한 progress를 우선 조회
    progress = await Progress.findOne({ where: { userId, storyId } });
    if (!progress) {
      // 해당 스토리의 progress가 없으면 새로 생성(슬롯은 자동으로 1로 설정)
      progress = await Progress.create({
        userId,
        storyId,
        slot: 1,
        lineIndex: 0,
      });
    }
  }

  // 2) 현재 인덱스의 노드 가져오기
  const node = await getScriptNode(storyId, currentIndex);
  if (!node || node.type !== "choice") {
    throw new CustomError({
      status: 400,
      code: "NOT_CHOICE_NODE",
      message: "선택지를 처리할 수 없는 위치입니다.",
    });
  }

  const choice = node.choices[choiceIndex];
  if (!choice) {
    throw new CustomError({
      status: 400,
      code: "INVALID_CHOICE_INDEX",
      message: "유효하지 않은 선택지 입니다.",
    });
  }

  const { targetIndex, heroineId, likeDelta = 0 } = choice;

  // 3) 히로인 호감도 업데이트 (heroine_like)
  if (heroineId && likeDelta !== 0) {
    const [like] = await HeroineLike.findOrCreate({
      where: { progressId: progress.id, heroineId },
      defaults: { likeValue: 0 },
    });

    like.likeValue = Math.max(0, like.likeValue + likeDelta);
    await like.save();
  }

  // 4) 진행 위치 업데이트
  progress.lineIndex = targetIndex;
  await progress.save();

  return {
    storyId,
    slot,
    nextIndex: targetIndex,
  };
};

// 다음 스토리로 이동
export const advanceToNextStory = async (userId, { slot }) => {
  const progress = await Progress.findOne({ where: { userId, slot } });
  if (!progress) throw CustomError.from(ProgressErrorCode.NOT_FOUND);

  const currentStory = await Story.findByPk(progress.storyId);
  if (!currentStory) throw CustomError.from(StoryErrorCode.NOT_FOUND);

  // nextStoryId 없으면 엔딩
  if (!currentStory.nextStoryId) {
    return { hasNext: false, message: "엔딩입니다." };
  }

  const nextStory = await Story.findByPk(currentStory.nextStoryId);

  // 진행 업데이트 (시작 index = 1)
  progress.storyId = nextStory.id;
  progress.lineIndex = 1;
  await progress.save();

  return {
    hasNext: true,
    storyId: nextStory.id,
    storyCode: nextStory.storyCode,
    lineIndex: 1,
  };
};

// Ensure there is a progress row for the user and story; create fallback if missing
// progress 레코드를 찾거나 생성합니다.
// - userId, storyId로 우선 조회
// - 없으면 해당 user의 아무 existing progress를 반환(있다면 재사용)
// - 그마저도 없으면 slot=1으로 새로운 progress를 생성합니다.
export const getOrCreateProgress = async (userId, storyId) => {
  let progress = await Progress.findOne({ where: { userId, storyId } });
  if (progress) return progress;

  progress = await Progress.findOne({ where: { userId } });
  if (progress) return progress;

  const created = await Progress.create({
    userId,
    storyId,
    slot: 1,
    lineIndex: 0,
  });
  return created;
};

// 호감도(affinity)를 적용합니다.
// - heroineName으로 heroine을 찾고, 해당 progress의 HeroineLike 행을 생성 또는 갱신합니다.
// - delta는 증감값(음수 허용)입니다.
// - 이 함수는 트랜잭션 없이 간단히 동작합니다. 필요 시 상위에서 sequelize.transaction으로 감싸 사용하세요.
export const applyAffinityChange = async (
  userId,
  storyId,
  heroineName,
  delta
) => {
  const heroine = await Heroine.findOne({ where: { name: heroineName } });
  if (!heroine) return null;

  const progress = await getOrCreateProgress(userId, storyId);

  const [like, created] = await HeroineLike.findOrCreate({
    where: { progressId: progress.id, heroineId: heroine.id },
    defaults: { likeValue: delta ?? 0 },
  });

  if (!created) {
    like.likeValue = (like.likeValue ?? 0) + (delta ?? 0);
    await like.save();
  }

  return like;
};

// ===== 엔딩 분기용 유틸 함수들 =====

// line(JSON 배열) + 호감도 배열로, 어느 엔딩 index로 갈지 결정
// - heroineLikes: [{ heroineId, likeValue }, ...]
// - threshold: 엔딩 기준 호감도 (기본 80)
const decideEndingIndex = (nodes, heroineLikes, threshold = 80) => {
  if (!Array.isArray(nodes)) return null;

  const candidates = (heroineLikes || []).filter(
    (hl) => (hl.likeValue ?? 0) >= threshold
  );

  let chosenHeroineId = null;

  if (candidates.length === 0) {
    // 아무도 기준 이상이 아니면 -> 솔로 엔딩
    chosenHeroineId = null;
  } else {
    // 여러 명이면 likeValue 가장 높은 히로인 1명 선택
    const best = candidates.reduce((max, cur) =>
      cur.likeValue > max.likeValue ? cur : max
    );
    chosenHeroineId = best.heroineId;
  }

  let endingNode;

  if (chosenHeroineId === null) {
    // 솔로 엔딩: solo=true 또는 heroineId 없는 ending 노드
    endingNode = nodes.find(
      (n) => n.type === "ending" && (n.solo === true || n.heroineId == null)
    );
  } else {
    // 히로인 엔딩: heroineId 매칭되는 ending 노드
    endingNode = nodes.find(
      (n) => n.type === "ending" && n.heroineId === chosenHeroineId
    );
  }

  return endingNode ? endingNode.index : null;
};

// 현재 위치에서 type === 'ending' 트리거를 만나면,
// 각 히로인 호감도 기준으로 실제 엔딩 함수
// - 사용 예: 프론트에서 ending 트리거 도달 시 호출index로 점프하는
export const jumpToEnding = async (userId, { slot, storyId }) => {
  // 1) progress + heroineLikes 조회
  const progress = await Progress.findOne({
    where: { userId, slot, storyId },
    include: [
      {
        model: HeroineLike,
        as: "heroineLikes",
      },
    ],
  });

  if (!progress) {
    throw CustomError.from(ProgressErrorCode.NOT_FOUND);
  }

  // 2) 해당 story의 전체 스크립트 JSON 가져오기
  const script = await Script.findOne({
    where: { storyId },
    attributes: ["line"],
  });

  if (!script || !Array.isArray(script.line)) {
    throw new CustomError({
      status: 500,
      code: "SCRIPT_NOT_FOUND",
      message: "엔딩 스크립트를 찾을 수 없습니다.",
    });
  }

  const nodes = script.line;
  const heroineLikes = progress.heroineLikes?.map((hl) => ({
    heroineId: hl.heroineId,
    likeValue: hl.likeValue,
  }));

  // 3) 어느 엔딩 index로 갈지 결정
  const endingIndex = decideEndingIndex(nodes, heroineLikes, 80);

  if (endingIndex == null) {
    throw new CustomError({
      status: 500,
      code: "ENDING_INDEX_NOT_FOUND",
      message: "조건에 맞는 엔딩 노드를 찾을 수 없습니다.",
    });
  }

  // 4) progress 위치를 엔딩 index로 이동
  progress.lineIndex = endingIndex;
  await progress.save();

  return {
    storyId,
    slot,
    nextIndex: endingIndex,
  };
};

// 새로운 엔딩 분기: 히로인 호감도(>=90)를 보고 특정 스토리로 이동
// - 후보가 여러명일 경우 likeValue가 가장 높은 히로인 선택
// - 선택된 히로인의 언어에 따라 이동할 스토리코드 매핑:
//    C -> '13', Java -> '14', Python -> '15'
// - 후보가 없으면 스토리코드 '16'으로 이동
export const jumpToAffinityStory = async (userId, { slot }) => {
  // allow optional slot: if slot is provided use it, otherwise find any progress for user
  const whereClause = typeof slot === "number" ? { userId, slot } : { userId };

  const progress = await Progress.findOne({
    where: whereClause,
    include: [
      {
        model: HeroineLike,
        as: "heroineLikes",
      },
    ],
  });

  if (!progress) throw CustomError.from(ProgressErrorCode.NOT_FOUND);

  const heroineLikes = (progress.heroineLikes || []).map((hl) => ({
    heroineId: hl.heroineId,
    likeValue: hl.likeValue || 0,
  }));

  // 후보: likeValue >= 90
  const candidates = heroineLikes.filter((h) => (h.likeValue || 0) >= 90);

  let targetStoryCode = "16"; // default if no candidate

  if (candidates.length > 0) {
    // pick highest likeValue
    const best = candidates.reduce((max, cur) =>
      cur.likeValue > max.likeValue ? cur : max
    );

    // find heroine to inspect language
    const heroine = await Heroine.findByPk(best.heroineId);
    const lang =
      heroine && heroine.language ? String(heroine.language).toLowerCase() : "";

    if (lang.includes("c")) targetStoryCode = "13";
    else if (lang.includes("java")) targetStoryCode = "14";
    else if (lang.includes("python")) targetStoryCode = "15";
    else targetStoryCode = "16";
  }

  const nextStory = await Story.findOne({
    where: { storyCode: targetStoryCode },
  });
  if (!nextStory) throw CustomError.from(StoryErrorCode.NOT_FOUND);

  // 이동: 시작 인덱스 1
  progress.storyId = nextStory.id;
  progress.lineIndex = 1;
  await progress.save();

  return {
    hasNext: true,
    storyId: nextStory.id,
    storyCode: nextStory.storyCode,
    lineIndex: 1,
  };
};
