  -- Example problem: 두 수 더하기 (simple sum)
  -- Inserts one problem and several testcases (3 public examples, 1 hidden)
  -- Adjust column names if your DB schema differs.

  START TRANSACTION;

  INSERT INTO `problem` (`key`, `title`, `content`, `level`, `stdout`, `story_id`, `description`)
  VALUES (
    'sum-two-numbers',
    '두 수 더하기',
    '정수 두 개가 공백으로 구분되어 주어집니다. 두 수의 합을 출력하세요.',
    1,
    NULL,
    3300,
    '간단한 덧셈 문제 예시'
  );

  -- get last inserted id (MySQL)
  SET @problem_id = LAST_INSERT_ID();

  -- Public example testcases (visible to users)
  INSERT INTO `testcase` (`content`, `input`, `expected`, `problem_id`, `order`, `is_public`)
  VALUES
    ('예제1','1 2','3', @problem_id, 10, 1),
    ('예제2','-5 7','2', @problem_id, 20, 1),
    ('예제3','100 200','300', @problem_id, 30, 1);

  -- Hidden testcases (used for 채점, not shown in public list)
  INSERT INTO `testcase` (`content`, `input`, `expected`, `problem_id`, `order`, `is_public`)
  VALUES
    ('숨겨진 1','123 456','579', @problem_id, 100, 0);

  COMMIT;

  -- Notes:
  -- 1) If your `testcase` table does not have `input`/`expected` columns
  --    or uses different names (e.g. `content` only), adjust the INSERTs accordingly.
  -- 2) Run with proper charset to avoid encoding issues for Korean text:
  --    mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3308 -u root -p2025 love_world < insert_example_problem.sql
