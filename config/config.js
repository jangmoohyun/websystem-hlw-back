import dotenv from 'dotenv';
dotenv.config();

export default {
    development: {
        username: process.env.DB_USER,
        password: process.env.DB_PASS,
        database: process.env.DB_NAME,
        host: process.env.DB_HOST,
        dialect: 'mysql',
        timezone: "+09:00",
        logging: false, // 콘솔에 SQL 로그 찍기 싫으면 false
    },
    test: {
        username: 'root',
        password: '1234',
        database: 'love_world_test',
        host: '127.0.0.1',
        dialect: 'mysql',
        timezone: "+09:00",
    },
    production: {
        username: process.env.DB_USER,
        password: process.env.DB_PASS,
        database: process.env.DB_NAME,
        host: process.env.DB_HOST,
        dialect: 'mysql',
        timezone: "+09:00",
    },
};
