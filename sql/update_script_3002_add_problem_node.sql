-- Update script for story 3002: add a problem node in the ML branch
START TRANSACTION;

SET @new_script = '[
  {"index":1,"type":"narration","text":"복도에 서 있는 세 사람. 서로 다음 수업을 확인한다."},
  {"index":2,"type":"dialogue","speaker":"이시현","text":"아, 다음 나 운영체제수업이지."},
  {"index":3,"type":"dialogue","speaker":"유자빈","text":"저는 분산병렬컴퓨팅 가요."},
  {"index":4,"type":"dialogue","speaker":"파인선","text":"저는 기계학습 수업 들으러 가요."},
  {"index":5,"type":"narration","text":"당신은 어느 수업으로 갈까?"},
  {"index":6,"type":"choice","choices":[
    {"text":"1. 운영체제 (시현)","targetIndex":100,"endIndex":103,"heroineName":"시현","affinityDelta":5,"branchStoryId":null},
    {"text":"2. 분병컴 (자빈)","targetIndex":200,"endIndex":203,"heroineName":"유자빈","affinityDelta":3,"branchStoryId":null},
    {"text":"3. Machine Learning (인선)","targetIndex":300,"endIndex":303,"heroineName":"파인선","affinityDelta":2,"branchStoryId":4000}
  ]},

  {"index":100,"type":"narration","text":"당신은 운영체제 강의실로 향한다. 시현이 옆에 앉아 있다."},
  {"index":101,"type":"dialogue","speaker":"시현","text":"여기 앉아도 돼?"},
  {"index":102,"type":"narration","text":"수업이 시작되고 운영체제의 커널 구조에 대한 설명이 이어진다."},
  {"index":103,"type":"narration","text":"(시현 루트 끝)"},

  {"index":200,"type":"narration","text":"당신은 분병컴 강의실로 향한다. 자빈이 이미 노트북을 꺼내고 있다."},
  {"index":201,"type":"dialogue","speaker":"자빈","text":"이번 실습 정말 기대돼요."},
  {"index":202,"type":"narration","text":"분산환경에서의 메시지 전달에 대한 사례가 설명된다."},
  {"index":203,"type":"narration","text":"(자빈 루트 끝)"},

  {"index":300,"type":"narration","text":"당신은 기계학습 강의실로 향한다. 인선은 창가에 앉아 조용히 준비 중이다."},
  {"index":301,"type":"dialogue","speaker":"인선","text":"오늘은 모델 평가 지표를 배워요."},
  {"index":302,"type":"narration","text":"실습으로 간단한 분류 문제를 풀게 된다."},
  {"index":305,"type":"problem","text":"간단한 덧셈 문제를 풀어보세요.","problemKey":"sum-two-numbers"},
  {"index":303,"type":"narration","text":"(인선 루트 끝)"}
]';

-- Update existing script row for story_id=3002
UPDATE `script` SET `line` = @new_script, `summary` = '갈림길 + 세 분기 (문제 노드 포함)' WHERE story_id = 3300;

-- If no script existed for story 3002, insert a new row
INSERT INTO `script` (`line`,`summary`,`story_id`)
SELECT @new_script, '갈림길 + 세 분기 (문제 노드 포함)', 3300
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `script` WHERE story_id = 3300);

COMMIT;

-- Run with:
-- mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3308 -u root -p2025 love_world < update_script_3002_add_problem_node.sql
