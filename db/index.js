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

        // 기존 progress 테이블이 잘못된 구조로 되어있을 수 있으므로 삭제 후 재생성
        try {
            await sequelize.query('DROP TABLE IF EXISTS `progress`');
            console.log('🗑️  기존 progress 테이블 삭제 완료');
        } catch (dropError) {
            // 테이블이 없으면 무시
        }

        await sequelize.sync({ alter: true });
        console.log('✅ Sequelize 모델과 DB 테이블 동기화 완료!');
    } catch (error) {
        console.error('❌ DB 초기화 실패:', error);
        // 개발 환경에서는 에러를 무시하고 서버 계속 실행
        if (process.env.NODE_ENV !== 'production') {
            console.warn('⚠️  DB 동기화 실패했지만 서버는 계속 실행됩니다.');
        } else {
            throw error;
        }
    }
};