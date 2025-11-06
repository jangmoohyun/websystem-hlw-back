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
        dialect: config.dialect,
        logging: config.logging,
    }
);

// 연결 테스트
export const connectDB = async () => {
    try {
        await sequelize.authenticate();
        console.log('✅ MySQL 연결 성공!');
    } catch (error) {
        console.error('❌ MySQL 연결 실패:', error);
    }
};