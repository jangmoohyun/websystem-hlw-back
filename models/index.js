import { DataTypes } from "sequelize";
import { sequelize } from "../db/index.js";

// 개별 모델 import
import userModel from "./user.js";
import progressModel from "./progress.js";
import storyModel from "./story.js";
import scriptModel from "./script.js";

import heroineModel from "./heroine.js";
import heroineImageModel from "./heroineImage.js";
import heroineLikeModel from "./heroineLike.js";
import blacklistedTokenModel from "./blacklistedToken.js";

import storyHeroineModel from "./storyHeroine.js";
import problemModel from "./problem.js";
import testcaseModel from "./testcase.js";
import userCodeModel from "./userCode.js";

const db = {};

// Sequelize 인스턴스 등록
db.sequelize = sequelize;

// 모델 초기화
db.User = userModel(sequelize, DataTypes);
db.Progress = progressModel(sequelize, DataTypes);
db.Story = storyModel(sequelize, DataTypes);
db.Script = scriptModel(sequelize, DataTypes);
db.StoryHeroine = storyHeroineModel(sequelize, DataTypes);
db.Heroine = heroineModel(sequelize, DataTypes);
db.HeroineImage = heroineImageModel(sequelize, DataTypes);
db.HeroineLike = heroineLikeModel(sequelize, DataTypes);

db.BlacklistedToken = blacklistedTokenModel(sequelize, DataTypes);

// 문제/테스트케이스 모델 등록 (기존 컨트롤러 호환을 위해 JudgeProblem/JudgeTestcase 별칭도 설정)
db.Problem = problemModel(sequelize, DataTypes);
db.Testcase = testcaseModel(sequelize, DataTypes);
db.UserCode = userCodeModel(sequelize, DataTypes);

// 관계 설정 (associate가 정의되어 있으면 실행)
Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

export default db;
