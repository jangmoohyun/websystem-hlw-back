# =============================================
# Stage 1: Build Stage
# TypeScript 컴파일 및 의존성 설치
# ============================================
FROM node:22-alpine AS builder

# 작업 디렉토리 설정
WORKDIR /app

# package.json과 package-lock.json 복사 (의존성 설치를 위해)
COPY package*.json ./

# 프로덕션 의존성만 설치 (빌드 도구 포함)
RUN npm ci --only=production=false

# 소스 코드 복사
COPY . .

# TypeScript 컴파일
RUN npm run build || (echo "Build script not found, skipping..." && true)

# ============================================
# Stage 2: Production Stage
# 최종 실행 이미지 (최소 크기)
# ============================================
FROM node:22-alpine AS production

# Non-root user 생성 및 설정
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# 작업 디렉토리 설정
WORKDIR /app

# package.json과 package-lock.json 복사
COPY package*.json ./

# 프로덕션 의존성만 설치 (빌드 도구 제외)
RUN npm ci --only=production && \
    npm cache clean --force

# 빌드 스테이지에서 컴파일된 파일 복사
COPY --from=builder /app/dist ./dist

# 소스 코드에서 필요한 파일 복사 (컴파일되지 않은 정적 파일 등)
# 필요에 따라 추가 파일 복사 가능
COPY --chown=nodejs:nodejs . .

# Non-root user로 전환
USER nodejs

# 포트 노출 (ECS Fargate 및 ALB 설정에 맞춤)
EXPOSE 8080

# 환경 변수 설정 (포트를 8080으로 설정)
ENV PORT=8080
ENV NODE_ENV=production

# 애플리케이션 시작 명령어
CMD ["npm", "start"]
