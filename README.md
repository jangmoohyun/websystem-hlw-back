# 백엔드 실행 방법

## 사전 요구사항
- Node.js (v14 이상)
- Docker 및 Docker Compose
- npm 또는 yarn

## 실행 단계

### 1. 의존성 설치
```bash
cd backend
npm install
```

### 2. 환경 변수 설정
`.env.example` 파일을 참고하여 `.env` 파일을 생성하세요.

```bash
cp .env.example .env
```

`.env` 파일을 열어서 필요한 값들을 설정하세요:
- `DB_USER`: MySQL 사용자명 (기본값: root)
- `DB_PASS`: MySQL 비밀번호 (기본값: 2025)
- `DB_NAME`: 데이터베이스 이름 (기본값: love_world)
- `DB_HOST`: 데이터베이스 호스트 (기본값: localhost)
- `DB_PORT`: 데이터베이스 포트 (기본값: 3306)
- `PORT`: 서버 포트 (기본값: 3000)
- `JWT_SECRET`: JWT 토큰 암호화용 비밀키

### 3. MySQL 데이터베이스 실행 (Docker)
```bash
docker-compose up -d
```

이 명령어는 MySQL 컨테이너를 백그라운드에서 실행합니다.

### 4. 서버 실행
```bash
npm start
```

서버가 정상적으로 실행되면 다음과 같은 메시지가 표시됩니다:
```
✅ MySQL 연결 성공!
✅ Sequelize 모델과 DB 테이블 동기화 완료!
🚀 Server listening on port 3000
```

## 추가 명령어

### MySQL 컨테이너 중지
```bash
docker-compose down
```

### MySQL 컨테이너 중지 및 데이터 삭제
```bash
docker-compose down -v
```

## 문제 해결

### 포트가 이미 사용 중인 경우
`.env` 파일에서 `PORT` 값을 다른 포트로 변경하세요 (예: 3001).

### 데이터베이스 연결 실패
1. Docker 컨테이너가 실행 중인지 확인: `docker ps`
2. `.env` 파일의 데이터베이스 설정이 올바른지 확인
3. MySQL 컨테이너 로그 확인: `docker-compose logs mysql`








