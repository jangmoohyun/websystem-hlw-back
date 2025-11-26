import { Sequelize } from 'sequelize';
import dbConfig from '../config/config.js';

const env = process.env.NODE_ENV || 'development';
const config = dbConfig[env];

// Sequelize 인스턴스 생성
export const sequelize = new Sequelize(
    config.database,
    config.username,
    config.password,
    {
        host: config.host,
        port: config.port,
        dialect: config.dialect,
        logging: config.logging,
        timezone: config.timezone,
    }
);

// DB 연결 + 테이블 생성(synchronize)
export const initDB = async () => {
    try {
        await sequelize.authenticate();
        console.log('✅ MySQL 연결 성공!');

        await sequelize.sync({ alter: true });
        console.log('✅ Sequelize 모델과 DB 테이블 동기화 완료!');
    } catch (error) {
        console.error('❌ DB 초기화 실패:', error);
    }
};