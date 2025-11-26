import { DataTypes } from 'sequelize';
import { sequelize } from '../db/index.js';

// 개별 모델 import
import userModel from './user.js';
import progressModel from './progress.js';
import storyModel from './story.js';
import scriptModel from './script.js';
import heroineModel from './heroine.js';
import heroineImageModel from './heroineImage.js';
import heroineLikeModel from './heroineLike.js';

const db = {};

// Sequelize 인스턴스 등록
db.sequelize = sequelize;

// 모델 초기화
db.User = userModel(sequelize, DataTypes);
db.Progress = progressModel(sequelize, DataTypes);
db.Story = storyModel(sequelize, DataTypes);
db.Script = scriptModel(sequelize, DataTypes);
db.Heroine = heroineModel(sequelize, DataTypes);
db.HeroineImage = heroineImageModel(sequelize, DataTypes);
db.HeroineLike = heroineLikeModel(sequelize, DataTypes);

// 관계 설정 (associate가 정의되어 있으면 실행)
Object.keys(db).forEach((modelName) => {
    if (db[modelName].associate) {
        db[modelName].associate(db);
    }
});

export default db;
