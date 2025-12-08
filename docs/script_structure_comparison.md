# Script 구조 비교: JSON vs 별도 테이블

## 현재 구조 (JSON 필드)

### 구조
```sql
script 테이블:
- id
- story_id
- line (JSON)  -- 모든 라인이 여기에 배열로 저장
- summary
```

### 장점
- ✅ 간단한 구조 (테이블 1개)
- ✅ 원자적 업데이트 (트랜잭션 간단)
- ✅ 전체 스크립트를 한 번에 로드 가능
- ✅ 순서 보장 (JSON 배열 순서)

### 단점
- ❌ 큰 스토리에서 성능 저하 (전체 JSON 로드)
- ❌ 특정 라인만 수정해도 전체 JSON 업데이트
- ❌ JSON 필드 크기 제한 (LONGTEXT: 최대 4GB지만 실용적이지 않음)
- ❌ 인덱싱 어려움 (특정 라인 검색 시 비효율)
- ❌ 메모리 사용량 증가

---

## 개선 방안 1: script_line 테이블 분리

### 구조
```sql
script 테이블:
- id
- story_id
- summary

script_line 테이블:
- id
- script_id (FK)
- index (순서)
- type (narration, dialogue, choice, problem)
- content (JSON)  -- 각 라인의 내용만
```

### 장점
- ✅ 특정 라인만 조회 가능 (성능 향상)
- ✅ 라인별 인덱싱 가능
- ✅ 부분 업데이트 가능
- ✅ 메모리 효율적
- ✅ 확장성 좋음

### 단점
- ❌ 테이블 2개 관리 필요
- ❌ 전체 스크립트 로드 시 JOIN 필요
- ❌ 순서 보장을 위해 index 관리 필요

---

## 개선 방안 2: 하이브리드 (권장)

### 구조
```sql
script 테이블:
- id
- story_id
- summary
- line (JSON)  -- 작은 스토리는 여기에 (백업/캐시용)

script_line 테이블:
- id
- script_id (FK)
- index
- type
- content (JSON)
```

### 사용 전략
- **작은 스토리 (< 50 lines)**: JSON 필드 사용 (빠른 로드)
- **큰 스토리 (> 50 lines)**: script_line 테이블 사용
- JSON 필드는 캐시/백업 용도로 유지

---

## 성능 비교

### 현재 구조 (JSON) - **실제 사용 패턴에 더 적합**

```javascript
// 게임 시작 시: 스크립트 전체를 한 번에 로드
const story = await Story.findByPk(storyId, {
  include: [{ model: Script, as: 'script' }]
});
// 프론트엔드로 전체 JSON 전송 (1번의 네트워크 요청)

// 프론트엔드에서:
const scriptLines = story.script.line;  // 전체 배열을 메모리에 캐싱
const currentNode = scriptLines.find(n => n.index === currentIndex);  // O(n)이지만 메모리 내
// 또는 Map으로 변환하여 O(1) 접근 가능
const lineMap = new Map(scriptLines.map(l => [l.index, l]));
const currentNode = lineMap.get(currentIndex);  // O(1)
```

**장점:**
- ✅ 네트워크 요청 1번만 (게임 시작 시)
- ✅ 프론트엔드에서 즉시 접근 가능 (캐싱)
- ✅ 순차적 읽기에 최적화 (게임 진행 패턴)
- ✅ Map 변환으로 O(1) 접근 가능

### 별도 테이블 구조

```javascript
// 전체 스크립트 로드 시
const lines = await ScriptLine.findAll({ 
  where: { scriptId },
  order: [['index', 'ASC']]
});  // 여러 라인을 한 번에 가져와야 함

// 또는 특정 라인만 가져오기
const node = await ScriptLine.findOne({ 
  where: { scriptId, index: 403 } 
});  // 매번 네트워크 요청 필요
```

**단점:**
- ❌ 전체 스크립트 로드 시 결국 모든 라인을 가져와야 함
- ❌ 여러 라인을 순차적으로 읽을 때 네트워크 요청 증가
- ❌ 프론트엔드에서 캐싱이 어려움

---

## 권장 사항: **현재 JSON 구조 유지** ✅

### 실제 사용 패턴 분석

게임 진행 시나리오에서는:
1. **게임 시작 시**: 스토리 전체 스크립트를 한 번에 로드
2. **게임 진행 중**: 프론트엔드에서 순차적으로 라인 읽기 (메모리 캐싱)
3. **선택지/분기**: 이미 로드된 스크립트 내에서 인덱스로 이동

이 패턴에 **JSON 구조가 최적**입니다:
- ✅ 한 번의 API 호출로 전체 스크립트 로드
- ✅ 프론트엔드에서 즉시 접근 (네트워크 지연 없음)
- ✅ Map 변환으로 O(1) 접근 가능
- ✅ 순차적 읽기에 최적화

### 별도 테이블 구조의 문제점

만약 `script_line` 테이블로 분리하면:
- ❌ 전체 스크립트 로드 시 결국 모든 라인을 가져와야 함 (JOIN 필요)
- ❌ 여러 번 나눠서 가져오면 네트워크 요청 증가 (비효율)
- ❌ 프론트엔드에서 캐싱이 어려움

### 결론: **현재 구조가 더 나음** ✅

**JSON 구조를 유지하되, 최적화 방법:**

1. **프론트엔드 최적화**
```javascript
// 스크립트 로드 후 Map으로 변환하여 O(1) 접근
const lineMap = new Map(scriptLines.map(l => [l.index, l]));

// 사용 시
const currentNode = lineMap.get(currentIndex);  // O(1)
```

2. **스토리 분할** (큰 스토리의 경우)
```
story_1 (씬 1: 50 lines)
  ↓ next_story_id
story_2 (씬 2: 50 lines)
  ↓ next_story_id  
story_3 (씬 3: 50 lines)
```

3. **크기 제한**
- 각 스토리는 100-200 lines 이하 권장
- JSON 크기는 약 100-500KB (충분히 관리 가능)

### 성능 비교 요약

| 항목 | JSON 구조 | script_line 테이블 |
|------|-----------|-------------------|
| 네트워크 요청 | 1번 (전체 로드) | 1번 (JOIN) 또는 N번 (비효율) |
| 프론트엔드 캐싱 | ✅ 쉬움 | ❌ 어려움 |
| 순차적 읽기 | ✅ 최적 | ❌ 네트워크 의존 |
| 특정 라인 접근 | O(1) with Map | O(log n) with DB |
| 메모리 사용 | 적당함 (100-500KB) | 비슷함 (결국 전체 로드) |

**결론: 현재 JSON 구조가 게임 시나리오에 더 적합합니다!** ✅


