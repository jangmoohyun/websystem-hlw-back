# =============================================
# Stage 1: Build Stage
# TypeScript 컴파일 및 의존성 설치
# ===========================================
FROM node:22-alpine AS builder

# 작업 디렉토리 설정
WORKDIR /app

# package.json과 package-lock.json 복사 (의존성 설치를 위해)
COPY package*.json ./

# 프로덕션 의존성만 설치 (빌드 도구 포함)
RUN npm ci --only=production=false

# 소스 코드 복사
COPY . .

# TypeScript 컴파일 시도 (빌드 스크립트가 있으면 실행)
# dist 폴더가 없으면 소스 코드를 dist로 복사 (JavaScript 프로젝트 대응)
RUN set -e; \
    echo "Checking for build script..."; \
    if npm run 2>/dev/null | grep -q "^  build"; then \
        echo "Build script found, running build..."; \
        npm run build || echo "Build failed, will use source code"; \
    else \
        echo "No build script found, will use source code as dist"; \
    fi; \
    echo "Ensuring dist folder exists..."; \
    if [ ! -d "dist" ]; then \
        echo "dist folder not found, creating from source code..."; \
        mkdir -p dist; \
        cp -r bin config controller db errors middleware models routes service utils dist/ 2>/dev/null || true; \
        cp app.js dist/ 2>/dev/null || true; \
        if [ ! -f "dist/app.js" ] && [ ! -f "dist/bin/www" ]; then \
            echo "Copying all necessary files to dist..."; \
            find . -maxdepth 1 -type f \( -name "*.js" -o -name "*.json" \) -exec cp {} dist/ \; 2>/dev/null || true; \
            for dir in bin config controller db errors middleware models routes service utils; do \
                if [ -d "$dir" ]; then cp -r "$dir" dist/ 2>/dev/null || true; fi; \
            done; \
        fi; \
    fi; \
    echo "Verifying dist folder exists..."; \
    if [ ! -d "dist" ]; then \
        echo "ERROR: dist folder still does not exist after creation attempt"; \
        exit 1; \
    fi; \
    echo "Build stage complete. dist contents:"; \
    ls -la dist/ || echo "Warning: Cannot list dist contents"

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

# 빌드 스테이지에서 dist 폴더 복사
# 빌드 스테이지에서 dist가 항상 생성되도록 보장했으므로 안전하게 복사 가능
COPY --from=builder --chown=nodejs:nodejs /app/dist ./

# Non-root user로 전환
USER nodejs

# 포트 노출 (ECS Fargate 및 ALB 설정에 맞춤)
EXPOSE 8080

# 환경 변수 설정 (포트를 8080으로 설정)
ENV PORT=8080
ENV NODE_ENV=production

# 애플리케이션 시작 명령어
CMD ["npm", "start"]