-- MySQL dump 10.13  Distrib 9.5.0, for Linux (x86_64)
--
-- Host: localhost    Database: love_world
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `love_world`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `love_world` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `love_world`;

--
-- Table structure for table `blacklisted_tokens`
--

DROP TABLE IF EXISTS `blacklisted_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blacklisted_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(500) NOT NULL,
  `expiresAt` datetime NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  UNIQUE KEY `blacklisted_tokens_token` (`token`),
  UNIQUE KEY `token_2` (`token`),
  UNIQUE KEY `token_3` (`token`),
  UNIQUE KEY `token_4` (`token`),
  UNIQUE KEY `token_5` (`token`),
  UNIQUE KEY `token_6` (`token`),
  UNIQUE KEY `token_7` (`token`),
  UNIQUE KEY `token_8` (`token`),
  KEY `blacklisted_tokens_expires_at` (`expiresAt`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blacklisted_tokens`
--

LOCK TABLES `blacklisted_tokens` WRITE;
/*!40000 ALTER TABLE `blacklisted_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `blacklisted_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `heroine`
--

DROP TABLE IF EXISTS `heroine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `heroine` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `language` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `heroine`
--

LOCK TABLES `heroine` WRITE;
/*!40000 ALTER TABLE `heroine` DISABLE KEYS */;
INSERT INTO `heroine` VALUES (1,'이시현','C'),(2,'유자빈','Python'),(3,'파인선','Java');
/*!40000 ALTER TABLE `heroine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `heroine_img`
--

DROP TABLE IF EXISTS `heroine_img`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `heroine_img` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `image_url` varchar(512) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `heroine_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `heroine_id` (`heroine_id`),
  CONSTRAINT `heroine_img_ibfk_1` FOREIGN KEY (`heroine_id`) REFERENCES `heroine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `heroine_img`
--

LOCK TABLES `heroine_img` WRITE;
/*!40000 ALTER TABLE `heroine_img` DISABLE KEYS */;
/*!40000 ALTER TABLE `heroine_img` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `heroine_like`
--

DROP TABLE IF EXISTS `heroine_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `heroine_like` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `likeValue` tinyint NOT NULL DEFAULT '0',
  `progress_id` bigint unsigned NOT NULL,
  `heroine_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `progress_id` (`progress_id`),
  KEY `heroine_id` (`heroine_id`),
  CONSTRAINT `heroine_like_ibfk_5` FOREIGN KEY (`progress_id`) REFERENCES `progress` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `heroine_like_ibfk_6` FOREIGN KEY (`heroine_id`) REFERENCES `heroine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `heroine_like`
--

LOCK TABLES `heroine_like` WRITE;
/*!40000 ALTER TABLE `heroine_like` DISABLE KEYS */;
INSERT INTO `heroine_like` VALUES (1,110,1,1),(2,15,1,3),(3,5,1,2);
/*!40000 ALTER TABLE `heroine_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem`
--

DROP TABLE IF EXISTS `problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `problem` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` text,
  `level` bigint DEFAULT NULL,
  `stdout` varchar(255) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem`
--

LOCK TABLES `problem` WRITE;
/*!40000 ALTER TABLE `problem` DISABLE KEYS */;
INSERT INTO `problem` VALUES (1,'simple_add_01','가벼운 덧셈 문제','두 정수 A와 B를 입력받아 A + B의 결과를 출력하세요.',1,NULL,'입력으로 두 정수가 주어지면 그 합을 출력하는 아주 기초적인 문제입니다.'),(2,'simple_mul_01','가벼운 곱셈 문제','두 정수 A와 B를 입력받아 A × B의 결과를 출력하세요.',1,NULL,'입력으로 두 정수가 주어지면 그 곱을 출력하는 아주 기초적인 문제입니다.');
/*!40000 ALTER TABLE `problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progress`
--

DROP TABLE IF EXISTS `progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `progress` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `slot` tinyint unsigned NOT NULL DEFAULT '1',
  `lineIndex` int unsigned NOT NULL DEFAULT '0',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `story_id` bigint unsigned DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_slot` (`user_id`,`slot`),
  KEY `story_id` (`story_id`),
  CONSTRAINT `progress_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progress_ibfk_6` FOREIGN KEY (`story_id`) REFERENCES `story` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progress`
--

LOCK TABLES `progress` WRITE;
/*!40000 ALTER TABLE `progress` DISABLE KEYS */;
INSERT INTO `progress` VALUES (1,1,0,'4c8beb47-874b-40c6-bafb-bcf1eefa18ef',4,'2025-12-09 03:35:17','2025-12-09 13:54:21');
/*!40000 ALTER TABLE `progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `script`
--

DROP TABLE IF EXISTS `script`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `script` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `line` json NOT NULL COMMENT '대사/선택지 JSON',
  `summary` varchar(255) DEFAULT NULL COMMENT '장면 설명',
  `story_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `story_id` (`story_id`),
  CONSTRAINT `script_ibfk_1` FOREIGN KEY (`story_id`) REFERENCES `story` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `script`
--

LOCK TABLES `script` WRITE;
/*!40000 ALTER TABLE `script` DISABLE KEYS */;
INSERT INTO `script` VALUES (1,'[{\"text\": \"(내 이름은 김철수. 스무 살에 입학했지만, 2년의 군 복무를 마치고 돌아오니 어느새 스물셋 복학생이 되어버렸다.)\", \"type\": \"dialogue\", \"index\": 1, \"speaker\": \"나\"}, {\"text\": \"(전공은 소프트웨어공학과. 코드 속의 논리는 그럭저럭 이해하겠는데, 현실 속의 인간관계 논리는 영 어렵다.)\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"나\"}, {\"text\": \"(그래서 동기들 사이에서 아싸(아웃사이더) 생활을 한 지도 벌써 일주일째.)\", \"type\": \"dialogue\", \"index\": 3, \"speaker\": \"나\"}, {\"text\": \"(군대 빼고 이성과의 교류가 전무했던 탓일까, 모태솔로 타이틀은 아직도 굳건하다.)\", \"type\": \"dialogue\", \"index\": 4, \"speaker\": \"나\"}, {\"text\": \"(이번 복학 생활에서는... 뭔가 달라질 수 있을까?)\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"나\"}, {\"type\": \"storyEnd\", \"index\": 6, \"nextStoryCode\": \"2\"}]','초입부 독백을 통한 주인공 대한 설명',1),(2,'[{\"text\": \"(이번 시간은 웹시스템 설계인가?)\", \"type\": \"dialogue\", \"index\": 1, \"speaker\": \"나\"}, {\"text\": \"(군대 가기 전에도 딱히 친한 동기 하나 없었는데, 복학 후 만난 낯선 20학번들 사이에서 나는 완벽한 아웃사이더, 아싸였다.)\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"나\"}, {\"text\": \"(팀 프로젝트가 있는 수업이라던데... 친구 없는데 어떡하지? 망했다...)\", \"type\": \"dialogue\", \"index\": 3, \"speaker\": \"나\"}, {\"text\": \"마음속으로 간절히 빌며 강의실로 들어섰다.\", \"type\": \"narration\", \"index\": 4}, {\"text\": \"교수님은 이미 팀 구성을 발표하고 있었다.\", \"type\": \"narration\", \"index\": 5}, {\"text\": \"다음은 김철수 학생 팀입니다.\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"교수님\"}, {\"text\": \"김철수 학생, 이시현 학생, 유자빈 학생, 파인선 학생.\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"교수님\"}, {\"text\": \"(...세 명 다 여자...? 그것도 소문난 여신들이라고?)\", \"type\": \"dialogue\", \"index\": 8, \"speaker\": \"나\"}, {\"text\": \"교수님의 안내에 따라 팀원들이 모여 앉기 시작했다.\", \"type\": \"narration\", \"index\": 9}, {\"text\": \"(떨리는데... 어쩌지...)\", \"type\": \"dialogue\", \"index\": 10, \"speaker\": \"나\"}, {\"text\": \"가장 먼저 말을 건 것은 짧은 머리에 도전적인 눈빛의 이시현이었다.\", \"type\": \"narration\", \"index\": 11}, {\"text\": \"뭐야, 너 복학생이었네? 팀 운 진짜 최악이다. 난 이시현. 잘하는 건 딱히 없고 대충 해칠 거니까 징징대는 거 싫거든.\", \"type\": \"dialogue\", \"index\": 12, \"speaker\": \"이시현\"}, {\"text\": \"이어 유자빈이 밝은 미소로 인사를 건넸다.\", \"type\": \"narration\", \"index\": 13}, {\"text\": \"안녕하세요 선배님! 저는 유자빈이에요. 전 PPT나 문서 작업은 자신 있어요. 같이 A+ 받아봐요!\", \"type\": \"dialogue\", \"index\": 14, \"speaker\": \"유자빈\"}, {\"text\": \"마지막으로 파인선이 수줍게 고개를 들었다.\", \"type\": \"narration\", \"index\": 15}, {\"text\": \"...저는 파인선이에요. 코딩은 아직 많이 부족하지만... 열심히 할게요. 잘 부탁드립니다.\", \"type\": \"dialogue\", \"index\": 16, \"speaker\": \"파인선\"}, {\"text\": \"(이 분위기... 나도 이제 자기소개해야겠지?)\", \"type\": \"dialogue\", \"index\": 17, \"speaker\": \"나\"}, {\"type\": \"choice\", \"index\": 18, \"choices\": [{\"text\": \"1) 나는 김철수고 이번 학기에 복학한 복학생이야. 잘 부탁해.\", \"heroineName\": null, \"affinityDelta\": 0}, {\"text\": \"2) 나는.. 김철수라고 해.. 잘 부탁..해.\", \"heroineName\": null, \"affinityDelta\": 0}, {\"text\": \"3) 음 너희들이 이번 학기 나카마(동료)들이군. 잘 부탁하지. 후후.\", \"heroineName\": \"all\", \"affinityDelta\": -5}]}, {\"text\": \"(모태솔로 복학생의 새로운 대학 생활... 이제부터 시작인가?)\", \"type\": \"dialogue\", \"index\": 19, \"speaker\": \"나\"}, {\"type\": \"storyEnd\", \"index\": 20, \"nextStoryCode\": \"3\"}]','팀 결성 장면: 세 히로인과의 첫 만남',2),(3,'[{\"text\": \"복도에서 시현, 자빈, 인선과 함께 다음 수업을 확인하고 있다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"아, 다음 나 운영체제수업이지. 휴강 안 했겠지? 귀찮게.\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"이시현\"}, {\"text\": \"저는 다음 강의가 분병컴(분산 병렬 컴퓨팅)이에요. 벌써부터 기대되네요!\", \"type\": \"dialogue\", \"index\": 3, \"speaker\": \"유자빈\"}, {\"text\": \"제... 저는 기계학습(Machine Learning) 수업 들으러 가야 해요.\", \"type\": \"dialogue\", \"index\": 4, \"speaker\": \"파인선\"}, {\"text\": \"그녀들이 각자 다른 방향으로 발걸음을 옮기려 한다. 내 다음 수업은 뭐였더라...?\", \"type\": \"narration\", \"index\": 5}, {\"type\": \"choice\", \"index\": 6, \"choices\": [{\"text\": \"1). 운영체제 (시현)\", \"heroineName\": \"이시현\", \"affinityDelta\": 10, \"branchStoryId\": 4}, {\"text\": \"2). 분병컴 (자빈)\", \"heroineName\": \"유자빈\", \"affinityDelta\": 10, \"branchStoryId\": 5}, {\"text\": \"3). 기계학습 (인선)\", \"heroineName\": \"파인선\", \"affinityDelta\": 10, \"branchStoryId\": 6}]}]','복도에서 세 과목 루트 선택',3),(4,'[{\"text\": \"강의실에 들어와 빈자리를 둘러본다. 맨 뒤에 간신히 한 자리가 남아 있다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"자리에 앉으려는 순간, 옆자리의 익숙한 가방이 눈에 들어온다.\", \"type\": \"narration\", \"index\": 2}, {\"text\": \"저 가방은... 시현이의 가방 같은데... 설마.\", \"type\": \"narration\", \"index\": 3}, {\"text\": \"그 순간, 시현이가 자리로 돌아온다.\", \"type\": \"narration\", \"index\": 4}, {\"text\": \"아 뭐야 너도 같은 수업이었어? 아씨 왜 하필 내 옆자리에 앉는 거야 자리도 많은데.\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"이시현\"}, {\"text\": \"아.. 미안 그냥 뒤가 편해서.. 불편하면 자리 옮길게..\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"플레이어\"}, {\"text\": \"뭘 또 옮기냐 찐따같이. 그냥 앉아. 대신 아는 척하지 마라.\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"이시현\"}, {\"text\": \"괜히 잘못한 것도 없는데 욕을 먹은 기분이다. 얼굴은 참 예쁜데, 성격은 꽤 까칠하다.\", \"type\": \"narration\", \"index\": 8}, {\"text\": \"자 이제 수업 시작하겠습니다. 이번 시간에는 @#@$%!#$...\", \"type\": \"dialogue\", \"index\": 9, \"speaker\": \"교수님\"}, {\"text\": \"수업에 집중해야 하는데 점점 무슨 소리인지 귀에 들어오지 않는다.\", \"type\": \"narration\", \"index\": 10}, {\"text\": \"으... 교수님의 수면 유도 효과는 굉장하다. 점점 눈이 감겨온다...\", \"type\": \"narration\", \"index\": 11}, {\"text\": \"... 잠시 동안 졸다가 정신을 차린다.\", \"type\": \"narration\", \"index\": 12}, {\"text\": \"헉, 얼마나 잔 거지? 벌써 저 정도 진도가 나갔다. 친구도 없어서 필기 빌려달라 할 사람도 없는데...\", \"type\": \"narration\", \"index\": 13}, {\"text\": \"혹시 시현이한테...? 옆자리 시현이를 조심스레 쳐다본다.\", \"type\": \"narration\", \"index\": 14}, {\"text\": \"졸고 있는 시현이의 모습이 보인다. 애도 졸고 있네... 근데 이쁘긴 하다.\", \"type\": \"narration\", \"index\": 15}, {\"meta\": [{\"image\": \"/illust/c1_1.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 16}, {\"meta\": [{\"image\": \"/illust/c1_2.png\", \"duration\": 1}], \"type\": \"illust\", \"index\": 17}, {\"text\": \"그 순간 시현이 눈을 뜨며 눈이 마주친다.\", \"type\": \"narration\", \"index\": 18}, {\"text\": \"헉.\", \"type\": \"narration\", \"index\": 19}, {\"text\": \"너 뭐야 음침하게 왜 쳐다보고 있는 거야.\", \"type\": \"dialogue\", \"index\": 20, \"speaker\": \"이시현\"}, {\"text\": \"머릿속이 하얘진다. 뭐라고 답해야 하지...?\", \"type\": \"narration\", \"index\": 21}, {\"type\": \"choice\", \"index\": 22, \"choices\": [{\"text\": \"1) 무.. 무슨 소리야 우연이거든..\", \"heroineName\": \"이시현\", \"affinityDelta\": -5}, {\"text\": \"2) 자는 모습이 이뻐서 보고 있었어.\", \"heroineName\": \"이시현\", \"affinityDelta\": 5}, {\"text\": \"3) 너가 졸고 있길래 깨워줄라 했지..\", \"heroineName\": \"이시현\", \"affinityDelta\": 0}]}, {\"text\": \"뭐래.. 얼마나 잔 거지. 벌써 저만큼 나갔네.. 아씨.\", \"type\": \"dialogue\", \"index\": 23, \"speaker\": \"이시현\"}, {\"text\": \"자 그럼 이번 시간 출석은 지금 내드리는 문제를 푸는 것으로 하겠습니다. 수업 끝날 때까지 제출해 주셔야 출석 인정이 됩니다.\", \"type\": \"dialogue\", \"index\": 24, \"speaker\": \"교수님\"}, {\"text\": \"수업 들은 게 없는데 벌써 수업이 끝나다니... 심지어 문제를 풀어야 출석이라니.\", \"type\": \"narration\", \"index\": 25}, {\"text\": \"문제를 받아 본다. 다행히 수업을 안 들어도 풀 수 있을 정도의 난이도다.\", \"type\": \"narration\", \"index\": 26}, {\"text\": \"야 너 벌써 다 했어? 다 했으면 나 좀 도와줘봐.\", \"type\": \"dialogue\", \"index\": 27, \"speaker\": \"이시현\"}, {\"text\": \"코드 문제를 함께 풀기 시작한다.\", \"type\": \"narration\", \"index\": 28}, {\"meta\": {\"effects\": [{\"type\": \"affinity\", \"delta\": 15, \"heroine\": \"이시현\"}], \"description\": \"출석 대체용 운영체제 기초 코드 문제\"}, \"type\": \"problem\", \"index\": 29}, {\"meta\": {\"condition\": \"pass\"}, \"text\": \"오. 보기보다 믿음직스럽네. 아무튼 고마워\", \"type\": \"dialogue\", \"index\": 30, \"speaker\": \"이시현\"}, {\"meta\": {\"condition\": \"fail\"}, \"text\": \"흥, 기대도 안 하고 있었어. 됐어 나 혼자 할게.\", \"type\": \"dialogue\", \"index\": 31, \"speaker\": \"이시현\"}, {\"text\": \"그럼 수업도 끝났겠다. 밥이나 먹으러 가볼까.\", \"type\": \"dialogue\", \"index\": 32, \"speaker\": \"이시현\"}, {\"text\": \"시현이는 짐을 챙겨 강의실을 나가 버렸다.\", \"type\": \"narration\", \"index\": 33}, {\"text\": \"그렇게 시현이와의 첫 수업이 끝났다. 나름 친해진 것 같아서 내심 기분은 좋다. 성격은 안 좋긴 하지만 말이다.\", \"type\": \"narration\", \"index\": 34}, {\"text\": \"다음 수업이 있나 시간표를 확인해 본다.\", \"type\": \"narration\", \"index\": 35}, {\"text\": \"흠, 오늘은 더 이상 수업이 없다. 이제 자유시간이군.\", \"type\": \"narration\", \"index\": 36}, {\"text\": \"이제 뭐 하면 좋을까...\", \"type\": \"narration\", \"index\": 37}, {\"type\": \"choice\", \"index\": 38, \"choices\": [{\"text\": \"1) 식당으로 간다\", \"branchStoryId\": 7}, {\"text\": \"2) 동아리방으로 간다\", \"branchStoryId\": 8}, {\"text\": \"3) 도서관으로 간다\", \"branchStoryId\": 9}]}]','운영체제 수업: 시현 첫 수업, 선택지 & 출석 문제',4),(5,'[{\"text\": \"강의실에 들어와 빈자리를 둘러본다. 맨 뒤에 간신히 한 자리가 남아 있다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"자리에 앉으려는 순간, 옆자리의 익숙한 가방이 눈에 들어온다.\", \"type\": \"narration\", \"index\": 2}, {\"text\": \"저 가방은... 자빈이의 가방 같은데... 설마.\", \"type\": \"narration\", \"index\": 3}, {\"text\": \"그 순간 자빈이가 자리로 돌아온다.\", \"type\": \"narration\", \"index\": 4}, {\"text\": \"어, 선배도 이 수업 들어요? 이렇게 보니까 되게 반갑네요 ㅎㅎ.\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"유자빈\"}, {\"text\": \"그러게..ㅎㅎ 혹시 자리 있어?\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"플레이어\"}, {\"text\": \"아뇨 빈 자리에요. 옆에 앉으세요, 같이 들어요! 잘됐네요. 이 수업에는 아는 사람이 없어서 혼자 들었었는데 앞으로 같이 들으면 되겠네요!\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"유자빈\"}, {\"text\": \"이건 자빈이랑 친해질 수 있는 기회인가? 그나저나 웃는 모습이 너무 다정하고 예쁘다. 나한테 이렇게 친절한데 혹시... 에이 아니겠지.\", \"type\": \"narration\", \"index\": 8}, {\"text\": \"자 이제 수업 시작하겠습니다. 이번 시간에는 @#@$%!#$...\", \"type\": \"dialogue\", \"index\": 9, \"speaker\": \"교수님\"}, {\"text\": \"수업에 집중해야 하는데 점점 무슨 소리인지 귀에 들어오지 않는다.\", \"type\": \"narration\", \"index\": 10}, {\"text\": \"으.. 교수님의 수면 유도 효과는 굉장하다... 점점 눈이 감겨온다...\", \"type\": \"narration\", \"index\": 11}, {\"text\": \"... 잠시 동안 졸다, 정신을 차린다.\", \"type\": \"narration\", \"index\": 12}, {\"text\": \"헉. 얼마나 잔 거지? 벌써 저 정도 진도가 나갔다. 친구도 없어서 필기 빌려달라 할 사람도 없는데...\", \"type\": \"narration\", \"index\": 13}, {\"text\": \"혹시 자빈이한테...? 옆자리 자빈이를 조심스레 쳐다본다.\", \"type\": \"narration\", \"index\": 14}, {\"text\": \"수업에 완전히 집중하고 있는 자빈의 모습이 보인다. 완전 집중해서 듣고 있네... 근데 이쁘긴 하다.\", \"type\": \"narration\", \"index\": 15}, {\"meta\": [{\"image\": \"/illust/java1_1.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 16}, {\"meta\": [{\"image\": \"/illust/java1_2.png\", \"duration\": 1}], \"type\": \"illust\", \"index\": 17}, {\"text\": \"그 순간 자빈이와 눈이 마주친다.\", \"type\": \"narration\", \"index\": 18}, {\"text\": \"헉.\", \"type\": \"narration\", \"index\": 19}, {\"text\": \"뭐에요. 제 얼굴에 뭐 묻었어요?\", \"type\": \"dialogue\", \"index\": 20, \"speaker\": \"유자빈\"}, {\"text\": \"갑작스러운 질문에 머릿속이 하얘진다. 뭐라고 답해야 하지...?\", \"type\": \"narration\", \"index\": 21}, {\"type\": \"choice\", \"index\": 22, \"choices\": [{\"text\": \"1) 아.. 아니야 우연이였어 미안해..\", \"heroineName\": \"유자빈\", \"affinityDelta\": 5}, {\"text\": \"2) 응, 이쁨이 묻어있는 거 같네 ㅎㅎ\", \"heroineName\": \"유자빈\", \"affinityDelta\": 0}, {\"text\": \"3) 아니야. 그나저나 수업 엄청 열심히 듣네, 대단해.\", \"heroineName\": \"유자빈\", \"affinityDelta\": -5}]}, {\"text\": \"뭐에요 ㅎㅎ.. 선배는 실컷 졸던데요?\", \"type\": \"dialogue\", \"index\": 23, \"speaker\": \"유자빈\"}, {\"text\": \"자 그럼 이번 시간 출석은 지금 내드리는 문제를 푸는 것으로 하겠습니다. 수업 끝날 때까지 제출해 주셔야 출석 인정이 됩니다.\", \"type\": \"dialogue\", \"index\": 24, \"speaker\": \"교수님\"}, {\"text\": \"수업 들은 게 없는데 벌써 수업이 끝나다니... 심지어 문제를 풀어야 출석이라니.\", \"type\": \"narration\", \"index\": 25}, {\"text\": \"문제를 받아 본다. 다행히 수업을 안 들어도 풀 수 있을 정도로군. 다행이다.\", \"type\": \"narration\", \"index\": 26}, {\"text\": \"선배님, 혹시 다 하셨으면 이 부분 도와주실 수 있을까요?\", \"type\": \"dialogue\", \"index\": 27, \"speaker\": \"유자빈\"}, {\"text\": \"코드 문제를 함께 풀기 시작한다.\", \"type\": \"narration\", \"index\": 28}, {\"meta\": {\"effects\": [{\"type\": \"affinity\", \"delta\": 15, \"heroine\": \"유자빈\"}], \"problemId\": 5, \"description\": \"출석 대체용 분산 병렬 컴퓨팅 기초 코드 문제\"}, \"type\": \"problem\", \"index\": 29}, {\"meta\": {\"condition\": \"pass\"}, \"text\": \"역시 선배님! 덕분에 잘 해결했어요. 감사합니다.\", \"type\": \"dialogue\", \"index\": 30, \"speaker\": \"유자빈\"}, {\"meta\": {\"condition\": \"fail\"}, \"text\": \"앗, 역시 문제는 혼자 풀어야겠죠. 도와주셔서 감사해요.\", \"type\": \"dialogue\", \"index\": 31, \"speaker\": \"유자빈\"}, {\"text\": \"그럼 수업도 끝났겠다. 동아리실에 가볼까. 선배, 다음에 봬요.\", \"type\": \"dialogue\", \"index\": 32, \"speaker\": \"유자빈\"}, {\"text\": \"자빈이는 짐을 챙겨 강의실을 나가 버렸다.\", \"type\": \"narration\", \"index\": 33}, {\"text\": \"그렇게 자빈이와의 첫 수업이 끝났다. 나름 친해진 것 같아서 내심 기분은 좋다. 나한테도 친절하게 대해주고... 이거 진짜 설마...\", \"type\": \"narration\", \"index\": 34}, {\"text\": \"그럼 다음 수업이 있나? 시간표를 확인해 본다.\", \"type\": \"narration\", \"index\": 35}, {\"text\": \"흠, 오늘은 더 이상 수업이 없다. 이제 자유시간이군.\", \"type\": \"narration\", \"index\": 36}, {\"text\": \"이제 뭐 하면 좋을까...\", \"type\": \"narration\", \"index\": 37}, {\"type\": \"choice\", \"index\": 38, \"choices\": [{\"text\": \"1) 식당으로 간다\", \"branchStoryId\": 7}, {\"text\": \"2) 동아리방으로 간다\", \"branchStoryId\": 8}, {\"text\": \"3) 도서관으로 간다\", \"branchStoryId\": 9}]}]','분병컴 수업: 자빈 첫 수업, 선택지 & 출석 문제',5),(6,'[{\"text\": \"강의실에 들어와 빈자리를 둘러본다. 맨 뒤에 간신히 한 자리가 남아 있다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"자리에 앉으려는 순간, 옆자리의 익숙한 가방이 눈에 들어온다.\", \"type\": \"narration\", \"index\": 2}, {\"text\": \"저 가방은... 인선이의 가방 같은데... 설마.\", \"type\": \"narration\", \"index\": 3}, {\"text\": \"그 순간 인선이가 자리로 돌아온다.\", \"type\": \"narration\", \"index\": 4}, {\"text\": \"@$#... 아.. 안녕하세요.. 여기 수업.. 이셨어요...?\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"파인선\"}, {\"text\": \"응 어쩌다 보니.. 옆에 자리 있을까?\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"플레이어\"}, {\"text\": \"아.. 아뇨.. 없어요. 여.. 옆에 앉으셔도 돼요..\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"파인선\"}, {\"text\": \"음, 내가 불편한가...? 낯을 많이 가리네. 친해지면 달라질까? 그래도 좀 귀엽긴 하네.\", \"type\": \"narration\", \"index\": 8}, {\"text\": \"자 이제 수업 시작하겠습니다. 이번 시간에는 @#@$%!#$...\", \"type\": \"dialogue\", \"index\": 9, \"speaker\": \"교수님\"}, {\"text\": \"수업에 집중해야 하는데 점점 무슨 소리인지 귀에 들어오지 않는다...\", \"type\": \"narration\", \"index\": 10}, {\"text\": \"으.. 교수님의 수면 유도 효과는 굉장하군... 점점 눈이 감겨온다...\", \"type\": \"narration\", \"index\": 11}, {\"text\": \"... 잠시 동안 졸다, 정신을 차린다.\", \"type\": \"narration\", \"index\": 12}, {\"text\": \"헉. 얼마나 잔 거지? 벌써 저 정도 진도 나갔네... 친구도 없어서 필기 빌려달라 할 사람도 없는데...\", \"type\": \"narration\", \"index\": 13}, {\"text\": \"혹시 인선이한테...? 옆자리 인선이를 조심스레 쳐다본다.\", \"type\": \"narration\", \"index\": 14}, {\"text\": \"졸고 있는 인선이의 모습이 보인다. 얘도 졸고 있네... 조는 모습도 귀여운걸.\", \"type\": \"narration\", \"index\": 15}, {\"meta\": [{\"image\": \"/illust/python1_1.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 16}, {\"meta\": [{\"image\": \"/illust/python1_2.png\", \"duration\": 1}], \"type\": \"illust\", \"index\": 17}, {\"text\": \"그 순간 인선이 눈을 뜨며 눈이 마주친다.\", \"type\": \"narration\", \"index\": 18}, {\"text\": \"헉.\", \"type\": \"narration\", \"index\": 19}, {\"text\": \"@#$$.. 저.. 저한테 무슨.. 볼 일이라도..?\", \"type\": \"dialogue\", \"index\": 20, \"speaker\": \"파인선\"}, {\"text\": \"갑작스러운 질문에 머릿속이 하얘진다. 뭐라고 답해야 하지...?\", \"type\": \"narration\", \"index\": 21}, {\"type\": \"choice\", \"index\": 22, \"choices\": [{\"text\": \"1) 아.. 아니야 우연이였어 미안해..\", \"heroineName\": \"파인선\", \"affinityDelta\": 0}, {\"text\": \"2) 자는 모습이 귀여워서 보고 있었달까.\", \"heroineName\": \"파인선\", \"affinityDelta\": -5}, {\"text\": \"3) 너가 졸고 있길래 깨워줄라 했지.\", \"heroineName\": \"파인선\", \"affinityDelta\": 5}]}, {\"text\": \"선배한테 이.. 이런.. 모습을 보이다니...\", \"type\": \"dialogue\", \"index\": 23, \"speaker\": \"파인선\"}, {\"text\": \"자 그럼 이번 시간 출석은 지금 내드리는 문제를 푸는 것으로 하겠습니다. 수업 끝날 때까지 제출해 주셔야 출석 인정이 됩니다.\", \"type\": \"dialogue\", \"index\": 24, \"speaker\": \"교수님\"}, {\"text\": \"수업 들은 게 없는데 벌써 수업이 끝나다니... 심지어 문제를 풀어야 출석이라니...\", \"type\": \"narration\", \"index\": 25}, {\"text\": \"문제를 받아 본다. 다행히 수업을 안 들어도 풀 수 있을 정도로군. 다행이다.\", \"type\": \"narration\", \"index\": 26}, {\"text\": \"저.. 저기 혹시.. 도.. 도와.. 주실 수 있을까요..?\", \"type\": \"dialogue\", \"index\": 27, \"speaker\": \"파인선\"}, {\"text\": \"코드 문제를 함께 풀기 시작한다.\", \"type\": \"narration\", \"index\": 28}, {\"meta\": {\"effects\": [{\"type\": \"affinity\", \"delta\": 15, \"heroine\": \"파인선\"}], \"problemId\": 5, \"description\": \"출석 대체용 공통 코드 문제\"}, \"type\": \"problem\", \"index\": 29}, {\"meta\": {\"condition\": \"pass\"}, \"text\": \"앗... 가.. 감사합니다. 덕분이에요...\", \"type\": \"dialogue\", \"index\": 30, \"speaker\": \"파인선\"}, {\"meta\": {\"condition\": \"fail\"}, \"text\": \"괘.. 괜찮아요... 도와주시려 했던 것만으로도 충분해요...\", \"type\": \"dialogue\", \"index\": 31, \"speaker\": \"파인선\"}, {\"text\": \"그.. 그럼.. 저는 이만.. 도서관에.. 가야해서요...\", \"type\": \"dialogue\", \"index\": 32, \"speaker\": \"파인선\"}, {\"text\": \"인선이는 짐을 챙겨 강의실을 나가 버렸다.\", \"type\": \"narration\", \"index\": 33}, {\"text\": \"그렇게 인선이와의 첫 수업이 끝났다. 나보다 낯을 가리는 애는 처음인걸. 계속 마주치다 보면 친해질 수 있겠지?\", \"type\": \"narration\", \"index\": 34}, {\"text\": \"그럼 다음 수업이 있나? 시간표를 확인해 본다.\", \"type\": \"narration\", \"index\": 35}, {\"text\": \"흠, 오늘은 더 이상 수업이 없다. 이제 자유시간이군.\", \"type\": \"narration\", \"index\": 36}, {\"text\": \"이제 뭐 하면 좋을까...\", \"type\": \"narration\", \"index\": 37}, {\"type\": \"choice\", \"index\": 38, \"choices\": [{\"text\": \"1) 식당으로 간다\", \"branchStoryId\": 7}, {\"text\": \"2) 동아리방으로 간다\", \"branchStoryId\": 8}, {\"text\": \"3) 도서관으로 간다\", \"branchStoryId\": 9}]}]','기계학습 수업: 인선 첫 수업, 선택지 & 출석 문제',6),(7,'[{\"text\": \"교내 식당에 들어선다. 사람들로 북적여 자리가 잘 보이지 않는다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"사람들이 엄청 많네.. 얼른 줄 서야겠다.\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"나\"}, {\"text\": \"줄을 서는데, 앞에 어딘가 익숙한 실루엣이 눈에 들어온다.\", \"type\": \"narration\", \"index\": 3}, {\"text\": \"(음, 시현이 아닌가..? 인사해야겠지 아무래도..)\", \"type\": \"dialogue\", \"index\": 4, \"speaker\": \"나\"}, {\"text\": \"저기.. 너도 밥먹으러 온거야?\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"나\"}, {\"text\": \"뭐야 너도 밥먹으려고 온 거야? 그나저나 오늘 식당 메뉴가 뭔지 알아?\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"이시현\"}, {\"type\": \"choice\", \"index\": 7, \"choices\": [{\"text\": \"1) 그런거..잘 모르는데..미안\", \"heroineName\": \"이시현\", \"affinityDelta\": -5}, {\"text\": \"2) 내가 그런거까지 알아야 되나?\", \"heroineName\": \"이시현\", \"affinityDelta\": 5}, {\"text\": \"3) 음 잘은 모르는데 찾아봐줄게.\", \"heroineName\": \"이시현\", \"affinityDelta\": 0}]}, {\"text\": \"아냐 됐어. 딱 보니까 카레인 거 같네. 뭐 같이 먹을 사람 없으면 같이 먹던가.\", \"type\": \"dialogue\", \"index\": 8, \"speaker\": \"이시현\"}, {\"text\": \"(얘가 웬일로 같이 먹자고 한대.. 어쨌든 대학교 와서 처음으로 같이 밥을 먹는거잖아.. 프로 혼밥러인 나에게는 상상도 못한 일이잖아 조금 설레는걸.)\", \"type\": \"dialogue\", \"index\": 9, \"speaker\": \"나\"}, {\"text\": \"음식을 받아 들고 자리를 찾아 함께 앉는다.\", \"type\": \"narration\", \"index\": 10}, {\"text\": \"으..카레에 당근 들어가있네. 당근 제일 싫어 완전 절대 최악.\", \"type\": \"dialogue\", \"index\": 11, \"speaker\": \"이시현\"}, {\"type\": \"choice\", \"index\": 12, \"choices\": [{\"text\": \"1) 그..그래도..농부들이 열심히 농사지은건데...\", \"heroineName\": \"이시현\", \"affinityDelta\": -5}, {\"text\": \"2) 애도 아니고 편식을 하네. 그냥 먹어.\", \"heroineName\": \"이시현\", \"affinityDelta\": 5}, {\"text\": \"3) 그래도 당근이 비타민 A가 풍부해서 몸에 좋아 한번 먹어봐.\", \"heroineName\": \"이시현\", \"affinityDelta\": 0}]}, {\"text\": \"에휴.. 알겠어 먹으면 되잖아..\", \"type\": \"dialogue\", \"index\": 13, \"speaker\": \"이시현\"}, {\"text\": \"(당근을 싫어하다니 센척은 다 하더니 은근 애같은 면이 있는걸?)\", \"type\": \"dialogue\", \"index\": 14, \"speaker\": \"나\"}, {\"text\": \"잠깐의 정적이 흐른다. 조금 어색한 분위기. 뭔가 대화 주제를 꺼내는 게 좋겠다는 생각이 든다.\", \"type\": \"narration\", \"index\": 15}, {\"type\": \"choice\", \"index\": 16, \"choices\": [{\"text\": \"1) 캠퍼스 내에서 찍은 고양이 이야기\", \"condition\": \"topic_cat\", \"heroineName\": \"이시현\", \"affinityDelta\": 5}, {\"text\": \"2) 재미있게 본 영화 love request 이야기\", \"condition\": \"topic_other\", \"heroineName\": \"이시현\", \"affinityDelta\": 0}, {\"text\": \"3) 재미있게 본 애니 그리디로 고백하려 했더니 DP가 필요했다 이야기\", \"condition\": \"topic_other\", \"heroineName\": \"이시현\", \"affinityDelta\": 0}]}, {\"meta\": {\"condition\": \"topic_cat\"}, \"text\": \"고양이가 뭐라고 흥. 사진 있으면 한번 보여줘 보던가\", \"type\": \"dialogue\", \"index\": 17, \"speaker\": \"이시현\"}, {\"meta\": {\"condition\": \"topic_cat\"}, \"text\": \"휴대폰을 꺼내 캠퍼스 내에서 찍은 고양이 사진을 보여준다.\", \"type\": \"narration\", \"index\": 18}, {\"meta\": {\"condition\": \"topic_cat\"}, \"text\": \"시현의 입꼬리가 살짝 올라간다.\", \"type\": \"narration\", \"index\": 19}, {\"meta\": {\"condition\": \"topic_cat\"}, \"text\": \"뭐 고양이가 귀엽긴 하네. 그렇다고 너가 사진을 잘 찍었다는건 아니야.\", \"type\": \"dialogue\", \"index\": 20, \"speaker\": \"이시현\"}, {\"meta\": {\"condition\": \"topic_other\"}, \"text\": \"시현이는 영화나 애니 이야기를 묵묵히 듣기만 한다. 별 반응 없이 카레만 떠먹는다.\", \"type\": \"narration\", \"index\": 21}, {\"meta\": {\"condition\": \"topic_other\"}, \"text\": \"(대화 주제가 재미없었나.. 나만 떠든거 같네..)\", \"type\": \"dialogue\", \"index\": 22, \"speaker\": \"나\"}, {\"text\": \"슬슬 다 먹은 것 같다. 자리에서 일어나려는 순간, 시현의 입가에 카레가 묻어있는 것이 눈에 들어온다.\", \"type\": \"narration\", \"index\": 23}, {\"type\": \"choice\", \"index\": 24, \"choices\": [{\"text\": \"1) 그..입가에 카레 묻은거 같은데..\", \"heroineName\": \"이시현\", \"affinityDelta\": -5}, {\"text\": \"2) 칠칠맞지 못하게 뭘 다 묻히고 먹냐 닦아.\", \"heroineName\": \"이시현\", \"affinityDelta\": 5}, {\"text\": \"3) 입가에 카레 조금 묻은거 같은데 냅킨 줄까?\", \"heroineName\": \"이시현\", \"affinityDelta\": 0}]}, {\"text\": \"아씨 뭐래..쪽팔리게 닦을거거든.\", \"type\": \"dialogue\", \"index\": 25, \"speaker\": \"이시현\"}, {\"text\": \"(은근 애같다니까.)\", \"type\": \"dialogue\", \"index\": 26, \"speaker\": \"나\"}, {\"text\": \"식당 안을 둘러보다가 벽면에 붙은 안내 문구를 발견한다.\", \"type\": \"narration\", \"index\": 27}, {\"text\": \"식사를 하신 분 한정 문제를 푸신 분께 소정의 상품이 있습니다.(교수님은 제외입니다) 라는 안내 방송이 흘러나온다.\", \"type\": \"narration\", \"index\": 28}, {\"text\": \"상품 진열대에 고양이 인형이 보인다. 시현에게 주면 좋아하려나 하는 생각이 스친다.\", \"type\": \"narration\", \"index\": 29}, {\"text\": \"우리 저거 한번 도전해 볼까?\", \"type\": \"dialogue\", \"index\": 30, \"speaker\": \"나\"}, {\"text\": \"해보던지 말던지. 자신 있으면 도전해봐.\", \"type\": \"dialogue\", \"index\": 31, \"speaker\": \"이시현\"}, {\"meta\": {\"effects\": [{\"type\": \"affinity\", \"delta\": 5, \"heroine\": \"이시현\"}], \"description\": \"식당 이벤트용 가벼운 곱셈 코드 문제\"}, \"type\": \"problem\", \"index\": 32}, {\"meta\": {\"condition\": \"pass\"}, \"text\": \"고양이 인형 귀엽네.. 뭐 너가 아니었어도 내가 풀어서 얻었을 거거든. 그래도 고맙다 뭐.\", \"type\": \"dialogue\", \"index\": 33, \"speaker\": \"이시현\"}, {\"meta\": {\"condition\": \"fail\"}, \"text\": \"어쩔 수 없지 뭐 별로 기대 안했어.\", \"type\": \"dialogue\", \"index\": 34, \"speaker\": \"이시현\"}, {\"text\": \"난 인제 집가야 되니까. 얼른 가. 내일 수업 때 보던가 말던가.\", \"type\": \"dialogue\", \"index\": 35, \"speaker\": \"이시현\"}, {\"text\": \"(대학 와서 처음으로 누군가랑 밥을 먹다니.. 그것도 시현이랑. 혼자 먹는것 보다 100배는 좋구나...)\", \"type\": \"dialogue\", \"index\": 36, \"speaker\": \"나\"}, {\"text\": \"(그래도 시현이랑 같이 밥도 먹고 많이 친해진거 같은데 다음에 또 같이 밥먹자 해볼까? ...아니다 욕이나 안먹으면 다행이지.)\", \"type\": \"dialogue\", \"index\": 37, \"speaker\": \"나\"}, {\"text\": \"식당을 나와 집으로 향하기로 한다. 오늘은 묘하게 기분이 좋은 하루다.\", \"type\": \"narration\", \"index\": 38}, {\"type\": \"storyEnd\", \"index\": 39, \"nextStoryCode\": \"10\"}]','교내 식당에서 시현과 첫 식사 및 덧셈 이벤트',7),(8,'[{\"text\": \"동아리 방 문 앞에 잠시 서 있는다. 문 앞에는 영화 감상 동아리라는 이름이 붙어 있다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"(동아리방은 가입하고 처음 와보는데… 지금이라도 돌아갈까 하는 생각이 스친다.)\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"나\"}, {\"text\": \"용기를 내어 문을 열고 들어가자, 조용히 노래를 듣던 자빈이 나를 보고 놀라며 눈을 크게 뜬다.\", \"type\": \"narration\", \"index\": 3}, {\"text\": \"어? 선배도 여기 동아리에요? 어서 와요!\", \"type\": \"dialogue\", \"index\": 4, \"speaker\": \"유자빈\"}, {\"type\": \"choice\", \"index\": 5, \"choices\": [{\"text\": \"1) 가볍게 인사한다.\", \"heroineName\": \"유자빈\", \"affinityDelta\": 0}, {\"text\": \"2) 어색하게 안..안녕..\", \"heroineName\": \"유자빈\", \"affinityDelta\": 5}, {\"text\": \"3) 밝게 오 반갑네, 너도 여기였어?\", \"heroineName\": \"유자빈\", \"affinityDelta\": -5}]}, {\"text\": \"선배도 영화 좋아하셨구나. 모르고 있었어요!\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"유자빈\"}, {\"text\": \"뭐..응, 가끔씩 봐.\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"나\"}, {\"text\": \"아 선배, 이거 한 번 들어보실래요? 제가 최근에 본 영화 OST인데, 진짜 좋아요!\", \"type\": \"dialogue\", \"index\": 8, \"speaker\": \"유자빈\"}, {\"text\": \"자빈이 이어폰 한 쪽을 내게 건네며 자연스럽게 가까이 다가온다. 코끝에 은은하게 과일 향이 스친다.\", \"type\": \"narration\", \"index\": 9}, {\"meta\": [{\"image\": \"/illust/java2.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 10}, {\"text\": \"(이어폰에서는 잔잔한 피아노 선율이 흐른다. 하지만 노래보다 심장 소리가 더 선명하게 들리는 건 기분 탓이겠지.)\", \"type\": \"dialogue\", \"index\": 11, \"speaker\": \"나\"}, {\"text\": \"어때요? 좋죠? 피아노 전주가 진짜… 좋아요.\", \"type\": \"dialogue\", \"index\": 12, \"speaker\": \"유자빈\"}, {\"type\": \"choice\", \"index\": 13, \"choices\": [{\"text\": \"1) 좋다… 전주가 특히...\", \"heroineName\": \"유자빈\", \"affinityDelta\": 5}, {\"text\": \"2) 괜찮네. 전주가 인상적이야.\", \"heroineName\": \"유자빈\", \"affinityDelta\": 0}, {\"text\": \"3) 자빈이 덕에 좋은 음악 알게됐네.\", \"heroineName\": \"유자빈\", \"affinityDelta\": -5}]}, {\"text\": \"그쵸! 선배도 뭘 좀 아시네요? 저 이 곡 요즘 하루 종일 들어요.\", \"type\": \"dialogue\", \"index\": 14, \"speaker\": \"유자빈\"}, {\"text\": \"자빈은 OST에 대해 한참 신나게 설명한다. 말이 멈추지 않는다. 좋아하는 걸 얘기할 때는 원래 이런가 보다.\", \"type\": \"narration\", \"index\": 15}, {\"text\": \"어느 순간 동아리방에는 자빈과 나 둘뿐이 되었다. 짧은 정적이 흐른다.\", \"type\": \"narration\", \"index\": 16}, {\"text\": \"(…뭔가 이야깃거리를 꺼내야 하나?)\", \"type\": \"dialogue\", \"index\": 17, \"speaker\": \"나\"}, {\"type\": \"choice\", \"index\": 18, \"choices\": [{\"text\": \"1) 캠퍼스 고양이 이야기\", \"condition\": \"other\", \"heroineName\": \"유자빈\", \"affinityDelta\": 0}, {\"text\": \"2) 영화 love request 이야기\", \"condition\": \"love_request\", \"heroineName\": \"유자빈\", \"affinityDelta\": 5}, {\"text\": \"3) 애니 DP가 필요했다 이야기\", \"condition\": \"other\", \"heroineName\": \"유자빈\", \"affinityDelta\": 0}]}, {\"meta\": {\"condition\": \"other\"}, \"text\": \".\", \"type\": \"dialogue\", \"index\": 19, \"speaker\": \"유자빈\"}, {\"meta\": {\"condition\": \"love_request\"}, \"text\": \"선배도 그 영화 보셨어요? 잘 모르는 영화인데, 전 완전 재밌게 봤어요!\", \"type\": \"dialogue\", \"index\": 20, \"speaker\": \"유자빈\"}, {\"meta\": {\"condition\": \"love_request\"}, \"text\": \"뭐.. 나도 영화를 꽤 좋아하니까.\", \"type\": \"dialogue\", \"index\": 21, \"speaker\": \"나\"}, {\"meta\": {\"condition\": \"love_request\"}, \"text\": \"완전 의외에요 선배. 저랑 잘 맞는 것 같아요 ㅎㅎ\", \"type\": \"dialogue\", \"index\": 22, \"speaker\": \"유자빈\"}, {\"meta\": {\"condition\": \"love_request\"}, \"text\": \"(이 얘기를 꺼내기 잘한 것 같군 후후..)\", \"type\": \"dialogue\", \"index\": 23, \"speaker\": \"나\"}, {\"meta\": {\"condition\": \"other\"}, \"text\": \"(자빈이는 계속 묵묵부답인 채 이야기를 듣기만 한다. 대화 주제가 재미없었나… 나만 떠든 것 같다.)\", \"type\": \"dialogue\", \"index\": 24, \"speaker\": \"나\"}, {\"meta\": {\"condition\": \"other\"}, \"text\": \"(대화 주제가 별로였나… 괜히 얘기했다.)\", \"type\": \"dialogue\", \"index\": 25, \"speaker\": \"나\"}, {\"text\": \"그러다 문득 나를 보며 자빈이 말문을 연다.\", \"type\": \"narration\", \"index\": 26}, {\"text\": \"아 참 선배, 이거 풀어볼래요? 저희 동아리에서 준비하는 행사인데 맞추면 상품 응모할 수 있어요.\", \"type\": \"dialogue\", \"index\": 27, \"speaker\": \"유자빈\"}, {\"text\": \"음, 뭔데?\", \"type\": \"dialogue\", \"index\": 28, \"speaker\": \"나\"}, {\"meta\": {\"effects\": [{\"type\": \"affinity\", \"delta\": 5, \"heroine\": \"유자빈\"}], \"description\": \"영화 동아리 행사용 간단한 코드 문제\"}, \"type\": \"problem\", \"index\": 29}, {\"meta\": {\"condition\": \"pass\"}, \"text\": \"와 선배 대단한데요?\", \"type\": \"dialogue\", \"index\": 30, \"speaker\": \"유자빈\"}, {\"meta\": {\"condition\": \"fail\"}, \"text\": \"뭐, 아쉽게도 틀렸어요 ㅎㅎ\", \"type\": \"dialogue\", \"index\": 31, \"speaker\": \"유자빈\"}, {\"text\": \"선배, 오늘… 되게 좋았어요. 같이 얘기해줘서 고마워요.\", \"type\": \"dialogue\", \"index\": 32, \"speaker\": \"유자빈\"}, {\"text\": \"(갑자기 이런 직진 멘트를..? 아 뭐라 답해야 하지..)\", \"type\": \"dialogue\", \"index\": 33, \"speaker\": \"나\"}, {\"type\": \"choice\", \"index\": 34, \"choices\": [{\"text\": \"1) 나..나도 좋았..어.\", \"heroineName\": \"유자빈\", \"affinityDelta\": 5}, {\"text\": \"2) 나도 자빈이 덕분에 즐거웠어 ㅎㅎ\", \"heroineName\": \"유자빈\", \"affinityDelta\": -5}, {\"text\": \"3) 그래, 다음에 또 얘기하자.\", \"heroineName\": \"유자빈\", \"affinityDelta\": 0}]}, {\"text\": \"네… 그러면 다음에 또 와요. 선배 오면… 좀 더 재밌을 것 같아서.\", \"type\": \"dialogue\", \"index\": 35, \"speaker\": \"유자빈\"}, {\"text\": \"(웃는 얼굴이 너무 밝아서, 괜히 내 기분까지 좋아진다.)\", \"type\": \"dialogue\", \"index\": 36, \"speaker\": \"나\"}, {\"text\": \"(동아리방 문을 나서며 생각한다.)\", \"type\": \"dialogue\", \"index\": 37, \"speaker\": \"나\"}, {\"text\": \"(…다음에 또 와야겠다.)\", \"type\": \"dialogue\", \"index\": 38, \"speaker\": \"나\"}, {\"type\": \"storyEnd\", \"index\": 39, \"nextStoryCode\": \"10\"}]','영화 동아리방에서 자빈과 OST, 코드 이벤트',8),(9,'[{\"text\": \"( 역시 학생이면 공부를 해야지.. 사람도 없어서 좋은걸?)\", \"type\": \"dialogue\", \"index\": 1, \"speaker\": \"나\"}, {\"text\": \"(웹 시스템 설계 책이 어디있지... 5A 구역이라고 했던 것 같은데...)\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"나\"}, {\"text\": \"책장 사이로 들어간 순간 인선과 마주친다. 흠칫 놀라는 인선은 눈을 한 번 마주치고는 쭈뼛거린다.\", \"type\": \"narration\", \"index\": 3}, {\"text\": \"(아까 만났는데도 낯을 가리네. 내가 먼저 인사해야겠지?)\", \"type\": \"dialogue\", \"index\": 4, \"speaker\": \"나\"}, {\"text\": \"ㅇ...앗.. 네.. 안ㄴ녕..하세요 선배...\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"파인선\"}, {\"text\": \"인선은 황급히 인사만 건네고 자리를 떠나버린다.\", \"type\": \"narration\", \"index\": 6}, {\"text\": \"(내가 불편한가... 친해지고 싶은데... 일단은 책부터 찾자.)\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"나\"}, {\"text\": \"잠시 둘러보니 웹 시스템 설계 책이 눈에 들어온다. 책을 들고 자리를 찾던 중, 구석에 앉아 있는 인선이 보인다.\", \"type\": \"narration\", \"index\": 8}, {\"text\": \"(같이 앉아도 되려나...)\", \"type\": \"dialogue\", \"index\": 9, \"speaker\": \"나\"}, {\"type\": \"choice\", \"index\": 10, \"choices\": [{\"text\": \"1) 옆에 앉아도 될까? 같이 공부하자.\", \"heroineName\": \"파인선\", \"affinityDelta\": 5}, {\"text\": \"2) 혹..혹시 옆에... 앉아도.. 돼?\", \"heroineName\": \"파인선\", \"affinityDelta\": 0}, {\"text\": \"3) 옆에 가방 좀 치워봐. 앉게.\", \"heroineName\": \"파인선\", \"affinityDelta\": -5}]}, {\"text\": \"ㄴ..네! 여..여기... 앉으세요....\", \"type\": \"dialogue\", \"index\": 11, \"speaker\": \"파인선\"}, {\"meta\": [{\"image\": \"/background/pythonLibrary.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 12}, {\"text\": \"인선이 앉은 의자 뒤로 지나가는데, 인선이 슬쩍 자기 노트를 몸으로 가린다. 뭔가 보여주면 안 될 것도 적어두었나 보다.\", \"type\": \"narration\", \"index\": 13}, {\"text\": \"그럼 공부 열심히 해.\", \"type\": \"dialogue\", \"index\": 14, \"speaker\": \"나\"}, {\"text\": \"%@#ㄴ..네..! 선배도..\", \"type\": \"dialogue\", \"index\": 15, \"speaker\": \"파인선\"}, {\"text\": \"(하, 이제 공부를 좀 해볼까?)\", \"type\": \"dialogue\", \"index\": 16, \"speaker\": \"나\"}, {\"text\": \"(하루 공부도 적정량이라는 게 있나 보다. 이제 머리에 안 들어가네. 잠깐 머리를 좀 식혀야겠다.)\", \"type\": \"dialogue\", \"index\": 17, \"speaker\": \"나\"}, {\"text\": \"옆을 슬쩍 쳐다보니 인선은 잔뜩 쭈그린 채 공책에 뭔가를 그리고 있다.\", \"type\": \"narration\", \"index\": 18}, {\"text\": \"(음료수라도 먹으면서 쉬자고 해야겠다. 선배답게 하나 사줘야지.)\", \"type\": \"dialogue\", \"index\": 19, \"speaker\": \"나\"}, {\"type\": \"choice\", \"index\": 20, \"choices\": [{\"text\": \"1) 이거라도 마시면서 해. 공부 많이 힘들지?\", \"heroineName\": \"파인선\", \"affinityDelta\": 5}, {\"text\": \"2) 이..이거 너 마셔..\", \"heroineName\": \"파인선\", \"affinityDelta\": 0}, {\"text\": \"3) 오다 주웠다.\", \"heroineName\": \"파인선\", \"affinityDelta\": -5}]}, {\"text\": \"ㅇ..아..! 감..감사합니다... 잘.. 마실게요..\", \"type\": \"dialogue\", \"index\": 21, \"speaker\": \"파인선\"}, {\"text\": \"(머리도 식힐 겸 잠깐 얘기나 나눠볼까? 어떤 주제를 꺼내는 게 좋을까..)\", \"type\": \"dialogue\", \"index\": 22, \"speaker\": \"나\"}, {\"type\": \"choice\", \"index\": 23, \"choices\": [{\"text\": \"1) 캠퍼스 내에서 찍은 고양이 이야기\", \"condition\": \"other\", \"heroineName\": \"파인선\", \"affinityDelta\": 0}, {\"text\": \"2) 재미있게 본 영화 love request 이야기\", \"condition\": \"other\", \"heroineName\": \"파인선\", \"affinityDelta\": 0}, {\"text\": \"3) 재미있게 본 애니 그리디로 고백하려 했더니 DP가 필요했다 이야기\", \"condition\": \"anime\", \"heroineName\": \"파인선\", \"affinityDelta\": 5}]}, {\"meta\": {\"condition\": \"other\"}, \"text\": \"(한껏 가라앉은 공기... 뭔가 더 분위기가 가라앉는 것 같다..)\", \"type\": \"dialogue\", \"index\": 24, \"speaker\": \"나\"}, {\"meta\": {\"condition\": \"other\"}, \"text\": \"(인선은 연거푸 고개만 끄덕이며 듣기만 한다. 별로 재미가 없었나?)\", \"type\": \"dialogue\", \"index\": 25, \"speaker\": \"나\"}, {\"meta\": {\"condition\": \"other\"}, \"text\": \"(괜히 나만 떠든 것 같은 분위기다.)\", \"type\": \"dialogue\", \"index\": 26, \"speaker\": \"나\"}, {\"meta\": {\"condition\": \"anime\"}, \"text\": \"애니 제목을 입에 담자마자 인선의 눈이 커진다. 조금 신나 보이는 모습이다.\", \"type\": \"narration\", \"index\": 27}, {\"meta\": {\"condition\": \"anime\"}, \"text\": \"선..선배도 그 애니 보셨어요? 저도 그거 엄..엄청 좋아하는데...\", \"type\": \"dialogue\", \"index\": 28, \"speaker\": \"파인선\"}, {\"meta\": {\"condition\": \"anime\"}, \"text\": \"원래 애니를 좀 좋아했어?\", \"type\": \"dialogue\", \"index\": 29, \"speaker\": \"나\"}, {\"meta\": {\"condition\": \"anime\"}, \"text\": \"그..그런건 아닌데... 선배는요..?\", \"type\": \"dialogue\", \"index\": 30, \"speaker\": \"파인선\"}, {\"meta\": {\"condition\": \"anime\"}, \"text\": \"나는 애니 엄청 좋아하지.. 너무 씹덕같나...?\", \"type\": \"dialogue\", \"index\": 31, \"speaker\": \"나\"}, {\"meta\": {\"condition\": \"anime\"}, \"text\": \"아!.. 아뇨 전혀 그렇게 안보여요..\", \"type\": \"dialogue\", \"index\": 32, \"speaker\": \"파인선\"}, {\"text\": \"그렇게 한참 애니 이야기를 나누다 보니, 주변에서 느껴지는 사람들의 시선이 신경 쓰이기 시작한다.\", \"type\": \"narration\", \"index\": 33}, {\"text\": \"(너무 시끄럽게 떠들었나... 조금 조용히 해야겠어.)\", \"type\": \"dialogue\", \"index\": 34, \"speaker\": \"나\"}, {\"type\": \"choice\", \"index\": 35, \"choices\": [{\"text\": \"1) 저..저기.. 우리 목소리가.. 너무 컸던 거 같아.. 쪽지로 대화할래..?\", \"heroineName\": \"파인선\", \"affinityDelta\": 0}, {\"text\": \"2) 우리가 조금 시끄러웠던 거 같은데, 그냥 쪽지로 하자.\", \"heroineName\": \"파인선\", \"affinityDelta\": -5}, {\"text\": \"3) 우리가 너무 시끄러웠던 건 아닐까? 괜찮으면 쪽지로 대화할까?\", \"heroineName\": \"파인선\", \"affinityDelta\": 5}]}, {\"text\": \"둘은 서로 공책을 오가며 쪽지를 주고받기 시작한다.\", \"type\": \"narration\", \"index\": 36}, {\"text\": \"(공부는 잘 돼가?)\", \"type\": \"dialogue\", \"index\": 37, \"speaker\": \"나\"}, {\"text\": \"아뇨..\", \"type\": \"dialogue\", \"index\": 38, \"speaker\": \"파인선\"}, {\"text\": \"선배 그럼.. 이것 좀 풀어주실 수 있나요..\", \"type\": \"dialogue\", \"index\": 39, \"speaker\": \"파인선\"}, {\"meta\": {\"effects\": [{\"type\": \"affinity\", \"delta\": 5, \"heroine\": \"파인선\"}], \"description\": \"도서관에서 인선이 가져온 코드 문제\"}, \"type\": \"problem\", \"index\": 40}, {\"meta\": {\"condition\": \"pass\"}, \"text\": \"고..고마워요... 선배\", \"type\": \"dialogue\", \"index\": 41, \"speaker\": \"파인선\"}, {\"meta\": {\"condition\": \"fail\"}, \"text\": \"괘..괜챃아요.. 제가 다시 할게요오..\", \"type\": \"dialogue\", \"index\": 42, \"speaker\": \"파인선\"}, {\"text\": \"(슬슬 시간도 늦어지는군..)\", \"type\": \"dialogue\", \"index\": 43, \"speaker\": \"나\"}, {\"text\": \"선배… 오늘… 감사했어요…\", \"type\": \"dialogue\", \"index\": 44, \"speaker\": \"파인선\"}, {\"text\": \"저… 다음에도… 같이 공부하고 싶어요…\", \"type\": \"dialogue\", \"index\": 45, \"speaker\": \"파인선\"}, {\"text\": \"…그래. 그래도 좋지.\", \"type\": \"dialogue\", \"index\": 46, \"speaker\": \"나\"}, {\"text\": \"인선은 얼굴이 빨개진 채로 작게 손을 흔들고는 도서관을 떠난다.\", \"type\": \"narration\", \"index\": 47}, {\"text\": \"(…은근 귀엽네. 진짜.)\", \"type\": \"dialogue\", \"index\": 48, \"speaker\": \"나\"}, {\"type\": \"storyEnd\", \"index\": 49, \"nextStoryCode\": \"10\"}]','도서관에서 인선과 공부 및 코드 이벤트',9),(10,'[{\"text\": \"(어느덧 조별과제 마지막 시간이다. 내일 발표만 하면 모든 게 끝나는군.)\", \"type\": \"dialogue\", \"index\": 1, \"speaker\": \"나\"}, {\"text\": \"약속된 카페에 도착하자, 이미 세 히로인이 자리에 앉아 있다.\", \"type\": \"narration\", \"index\": 2}, {\"meta\": [{\"image\": \"/illust/cafe.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 3}, {\"text\": \"늦었네? 아 진짜, 복학생이라 그런가 느긋한 거 봐.\", \"type\": \"dialogue\", \"index\": 4, \"speaker\": \"이시현\"}, {\"text\": \"(말은 저렇게 해도 표정은 별로 화난 것 같지 않은데...)\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"나\"}, {\"text\": \"선배! 여기 자리 잡아놨어요. 저희 지금 자료 검토하고 있었어요!\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"유자빈\"}, {\"text\": \"아..안녕하세요 발표 대본… 조금만 더 보면 될 것 같아요…\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"파인선\"}, {\"text\": \"(좋아… 이제 조별과제의 마무리를 장식해볼까.)\", \"type\": \"dialogue\", \"index\": 8, \"speaker\": \"나\"}, {\"text\": \"일단 PPT는 다 마무리했어요! 구조도랑 흐름도도 확인했고요.\", \"type\": \"dialogue\", \"index\": 9, \"speaker\": \"유자빈\"}, {\"text\": \"시연 영상은 내가 했어. 버그는… 뭐 없어. 아마도.\", \"type\": \"dialogue\", \"index\": 10, \"speaker\": \"이시현\"}, {\"text\": \"(아마도…?)\", \"type\": \"dialogue\", \"index\": 11, \"speaker\": \"나\"}, {\"text\": \"선배… 그… 어제 말한 부분… 이렇게 정리해봤는데… 어떤가요…?\", \"type\": \"dialogue\", \"index\": 12, \"speaker\": \"파인선\"}, {\"text\": \"와… 인선이 이거 다 했어? 잘했다.\", \"type\": \"dialogue\", \"index\": 13, \"speaker\": \"나\"}, {\"text\": \"아… 아뇨… 그냥 조금…!\", \"type\": \"dialogue\", \"index\": 14, \"speaker\": \"파인선\"}, {\"text\": \"(이제 발표 연습해볼까?)\", \"type\": \"dialogue\", \"index\": 15, \"speaker\": \"나\"}, {\"text\": \"발표는 선배랑 제가 맡는 걸로요! 목소리 톤이 잘 맞아요!\", \"type\": \"dialogue\", \"index\": 16, \"speaker\": \"유자빈\"}, {\"text\": \"질문 들어오면 내가 받아줄게. 어차피 내가 코드 제일 잘 아니까.\", \"type\": \"dialogue\", \"index\": 17, \"speaker\": \"이시현\"}, {\"text\": \"저는… 뒤에서 슬라이드 넘길게요…!\", \"type\": \"dialogue\", \"index\": 18, \"speaker\": \"파인선\"}, {\"text\": \"발표 연습이 시작된다. 흐름은 매끄럽고 팀워크도 좋다.\", \"type\": \"narration\", \"index\": 19}, {\"text\": \"연습을 마치고 잠시 휴식 시간을 갖는다.\", \"type\": \"narration\", \"index\": 20}, {\"text\": \"아 배고프다. 케이크 하나 시킬까? 너도 먹을 거지?\", \"type\": \"dialogue\", \"index\": 21, \"speaker\": \"이시현\"}, {\"text\": \"(오늘은 시현이가 좀 부드럽네?)\", \"type\": \"dialogue\", \"index\": 22, \"speaker\": \"나\"}, {\"text\": \"선배! 오늘 고생했으니까 제가 케이크 사드릴게요!\", \"type\": \"dialogue\", \"index\": 23, \"speaker\": \"유자빈\"}, {\"text\": \"저는… 커피 리필하고 올게요… 선배 것도요…\", \"type\": \"dialogue\", \"index\": 24, \"speaker\": \"파인선\"}, {\"text\": \"(이게… 행복이구나…) \", \"type\": \"dialogue\", \"index\": 25, \"speaker\": \"나\"}, {\"type\": \"choice\", \"index\": 26, \"choices\": [{\"text\": \"1) 다들 오늘 정말 고생했어. 특히 시현이 잘했어.\", \"heroineName\": \"이시현\", \"affinityDelta\": 5}, {\"text\": \"2) 다들..고생했어..자빈이는 나 챙겨줘서 고마워..\", \"heroineName\": \"유자빈\", \"affinityDelta\": 5}, {\"text\": \"3) 인선아, 아까 메모 정리한 거 진짜 잘했어.\", \"heroineName\": \"파인선\", \"affinityDelta\": 5}]}, {\"text\": \"맞아요! 우리 완전 팀워크 좋지 않아요?\", \"type\": \"dialogue\", \"index\": 27, \"speaker\": \"유자빈\"}, {\"text\": \"흠… 뭐 나쁘진 않았네.\", \"type\": \"dialogue\", \"index\": 28, \"speaker\": \"이시현\"}, {\"text\": \"다..다들… 감사해요\", \"type\": \"dialogue\", \"index\": 29, \"speaker\": \"파인선\"}, {\"text\": \"(이제 정말 끝이 보인다… 내일만 잘하면 된다.)\", \"type\": \"dialogue\", \"index\": 30, \"speaker\": \"나\"}, {\"text\": \"선배! 내일 발표 전에 단톡 꼭 확인하세요!\", \"type\": \"dialogue\", \"index\": 31, \"speaker\": \"유자빈\"}, {\"text\": \"내일 발표 때 버벅거리면 가만 안 둔다. 알지?\", \"type\": \"dialogue\", \"index\": 32, \"speaker\": \"이시현\"}, {\"text\": \"내일… 파이팅이에요… 선배…\", \"type\": \"dialogue\", \"index\": 33, \"speaker\": \"파인선\"}, {\"text\": \"(조별과제… 생각보다 나쁘지 않았네.)\", \"type\": \"dialogue\", \"index\": 34, \"speaker\": \"나\"}, {\"text\": \"(아니… 오히려 좀 좋았나?)\", \"type\": \"dialogue\", \"index\": 35, \"speaker\": \"나\"}, {\"type\": \"storyEnd\", \"index\": 36, \"nextStoryCode\": \"11\"}]','조별과제 마지막 준비 카페에서의 최종 점검',10),(11,'[{\"text\": \"(어느덧 발표날이다. 떨린다… 내가 잘할 수 있을까…)\", \"type\": \"dialogue\", \"index\": 1, \"speaker\": \"나\"}, {\"text\": \"강의실 앞줄에는 이미 조별과제를 준비해온 팀들이 하나둘씩 앉아 있다.\", \"type\": \"narration\", \"index\": 2}, {\"text\": \"프로젝터 화면에는 오늘 발표 순서가 떠 있고, 우리 팀 이름도 그 안에 선명하게 적혀 있다.\", \"type\": \"narration\", \"index\": 3}, {\"text\": \"선배, 긴장되시죠? 그래도 어제까지 연습 많이 했으니까 괜찮아요!\", \"type\": \"dialogue\", \"index\": 4, \"speaker\": \"유자빈\"}, {\"text\": \"떨면 진짜 바보임. 그냥 평소처럼만 하면 돼. 알지?\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"이시현\"}, {\"text\": \"저도… 뒤에서 슬라이드 잘 넘길게요… 선배만 믿고 있을게요…\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"파인선\"}, {\"text\": \"(…그래, 이 정도면 괜찮겠지. 우리, 진짜 열심히 준비했으니까.)\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"나\"}, {\"text\": \"다음 팀, 김철수 팀 발표 준비하세요.\", \"type\": \"dialogue\", \"index\": 8, \"speaker\": \"교수님\"}, {\"text\": \"심장이 쿵 내려앉는 느낌과 함께, 네 명이 함께 자리에서 일어나 단상 앞으로 향한다.\", \"type\": \"narration\", \"index\": 9}, {\"text\": \"(괜찮아… 숨 한번 크게 쉬고… 그대로 하면 돼.)\", \"type\": \"dialogue\", \"index\": 10, \"speaker\": \"나\"}, {\"text\": \"조용해진 강의실, 스포트라이트처럼 느껴지는 시선들. 드디어 발표가 시작된다.\", \"type\": \"narration\", \"index\": 11}, {\"text\": \"안녕하세요. 저희 팀은 웹 시스템 설계 조별과제 결과를 발표하겠습니다.\", \"type\": \"dialogue\", \"index\": 12, \"speaker\": \"나\"}, {\"text\": \"처음 문장을 떼는 순간까지만 해도 입술이 살짝 떨렸지만, 슬라이드가 넘어갈수록 점점 목소리가 안정되기 시작한다.\", \"type\": \"narration\", \"index\": 13}, {\"text\": \"다음은 시스템 전체 구조와 데이터 흐름에 대한 설명입니다.\", \"type\": \"dialogue\", \"index\": 14, \"speaker\": \"유자빈\"}, {\"text\": \"여기 보이는 부분이 실제 구현한 기능의 주요 흐름이고, 이 쪽은 예외 처리 로직입니다.\", \"type\": \"dialogue\", \"index\": 15, \"speaker\": \"이시현\"}, {\"text\": \"마지막으로… 저희 서비스가 가지는 기대 효과와… 향후 확장 방향에 대해 말씀드리겠습니다…\", \"type\": \"dialogue\", \"index\": 16, \"speaker\": \"파인선\"}, {\"text\": \"질문 시간, 몇 가지 날카로운 질문이 들어오지만 세 명이 차례대로 침착하게 답변해 나간다.\", \"type\": \"narration\", \"index\": 17}, {\"text\": \"(어쩌구 저쩌구… 정신없이 지나갔는데… 그래도 크게 실수한 건 없었던 것 같은데…?)\", \"type\": \"dialogue\", \"index\": 18, \"speaker\": \"나\"}, {\"text\": \"네, 수고했습니다. 다음 팀 준비하세요.\", \"type\": \"dialogue\", \"index\": 19, \"speaker\": \"교수님\"}, {\"text\": \"단상에서 내려오자, 긴장이 한꺼번에 풀리며 다리가 살짝 후들거리는 느낌이 든다.\", \"type\": \"narration\", \"index\": 20}, {\"text\": \"(…무사히 발표를 마친 것 같다.)\", \"type\": \"dialogue\", \"index\": 21, \"speaker\": \"나\"}, {\"text\": \"선배, 진짜 잘했어요! 중간에 예시 들어주신 부분 완전 좋았어요.\", \"type\": \"dialogue\", \"index\": 22, \"speaker\": \"유자빈\"}, {\"text\": \"생각보다 멀쩡했네? 버벅거리면 한 소리 하려고 했는데, 봐준다.\", \"type\": \"dialogue\", \"index\": 23, \"speaker\": \"이시현\"}, {\"text\": \"저… 선배 발표 들으면서… 저도 모르게 메모 더 하고 있었어요… 멋있었어요…\", \"type\": \"dialogue\", \"index\": 24, \"speaker\": \"파인선\"}, {\"text\": \"(이렇게 칭찬을 듣다니… 괜히 얼굴이 뜨거워진다.)\", \"type\": \"dialogue\", \"index\": 25, \"speaker\": \"나\"}, {\"text\": \"(어쨌든… 무사히 발표를 마친 것 같다. 조별과제도 끝났고… 이 아이들이랑의 인연은, 이제부터가 진짜 시작일까?)\", \"type\": \"dialogue\", \"index\": 26, \"speaker\": \"나\"}, {\"type\": \"storyEnd\", \"index\": 27, \"nextStoryCode\": \"12\"}]','조별과제 발표 당일 무사히 발표를 마친 후',11),(12,'[{\"text\": \"어느덧 수업이 끝나가고, 문득 생각에 잠겼다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"(길다면 길고… 짧다면 짧은 조별과제가 끝났군.)\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"나\"}, {\"text\": \"(처음엔 그냥 부담스러운 과제였는데… 어느새 이 애들과 보내는 시간이 꽤 즐거웠지.)\", \"type\": \"dialogue\", \"index\": 3, \"speaker\": \"나\"}, {\"text\": \"(뭔가… 시원섭섭하달까나… 과제 끝난 건 좋지만, 이대로 끝이라면 조금 아쉽기도 하고…) \", \"type\": \"dialogue\", \"index\": 4, \"speaker\": \"나\"}, {\"text\": \"강의실 창밖으로 지는 햇살이 책상 위를 비추며 조용한 여운을 남긴다.\", \"type\": \"narration\", \"index\": 5}, {\"text\": \"(이제 좀 친해진 것 같은데… 앞으로도 계속 볼 수 있으려나? 아니면 이게 끝일까…)\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"나\"}, {\"text\": \"(그러고 보니… 누구랑 제일 친해졌더라…?)\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"나\"}, {\"type\": \"choice\", \"index\": 8, \"choices\": [{\"text\": \"1) 시현이가 제일 먼저 떠오른다.\", \"heroineName\": \"이시현\", \"affinityDelta\": 5}, {\"text\": \"2) 자빈이랑 가장 대화가 잘 통했던 것 같다.\", \"heroineName\": \"유자빈\", \"affinityDelta\": 5}, {\"text\": \"3) 인선이… 은근히 신경 쓰인다.\", \"heroineName\": \"파인선\", \"affinityDelta\": 5}]}, {\"type\": \"Ending\", \"index\": 9}]','조별과제 종료 후 엔딩 선택',12),(13,'[{\"text\": \"수업이 끝나고 강의실을 나서려던 순간, 누군가가 내 이름을 부른다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"야, 잠깐.\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"이시현\"}, {\"text\": \"뒤를 돌아보니 시현이 내 앞으로 걸어오고 있었다.\", \"type\": \"narration\", \"index\": 3}, {\"meta\": [{\"image\": \"/illust/c_end.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 4}, {\"text\": \"(무슨 일이지…? 분위기가 평소보다 조금 다른데…) \", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"나\"}, {\"text\": \"그… 프로젝트 하느라 뭐… 고생했다. 딱히 너라서 좋았던 건 아니고… 그냥… 뭐랄까…\", \"type\": \"dialogue\", \"index\": 6, \"speaker\": \"이시현\"}, {\"text\": \"시현은 말을 제대로 고르지 못하고, 결국 고개를 살짝 돌려 버린다.\", \"type\": \"narration\", \"index\": 7}, {\"text\": \"…앞으로도 가끔 밥 정도는… 먹어도 되지?\", \"type\": \"dialogue\", \"index\": 8, \"speaker\": \"이시현\"}, {\"text\": \"(그녀다운… 투명한 츤데레 방식이다.)\", \"type\": \"dialogue\", \"index\": 9, \"speaker\": \"나\"}, {\"text\": \"응. 언제든지.\", \"type\": \"dialogue\", \"index\": 10, \"speaker\": \"나\"}, {\"text\": \"(나에게도… 드디어 사랑이 찾아오나…)\", \"type\": \"dialogue\", \"index\": 11, \"speaker\": \"나\"}, {\"type\": \"End\", \"index\": 12}]','이시현 루트 엔딩 (일러스트 포함)',14),(14,'[{\"text\": \"수업이 모두 끝난 뒤, 가방을 정리하고 일어서려는 순간 누군가 다가온다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"선배! 잠깐만요!\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"유자빈\"}, {\"text\": \"뒤돌아보니 자빈이 손을 살짝 흔들며 환하게 미소 짓고 있었다.\", \"type\": \"narration\", \"index\": 3}, {\"meta\": [{\"image\": \"/illust/java_end.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 4}, {\"text\": \"선배, 저희 조 발표 진짜 잘한 거 아세요? 선배랑 해서 더 재밌었어요.\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"유자빈\"}, {\"text\": \"자빈은 무언가 말하고 싶은 듯 입술을 달싹거리며 잠시 머뭇거린다.\", \"type\": \"narration\", \"index\": 6}, {\"text\": \"…그… 지난번 영화 같이 보기로 한 거, 진짜로 가요. 제가 예매할게요!\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"유자빈\"}, {\"text\": \"자빈은 바로 휴대폰을 꺼내 영화 예매창을 연다. 기대에 찬 눈빛이 반짝인다.\", \"type\": \"narration\", \"index\": 8}, {\"text\": \"좋아. 같이 보러 가자.\", \"type\": \"dialogue\", \"index\": 9, \"speaker\": \"나\"}, {\"text\": \"말이 채 끝나기도 전에, 자빈의 얼굴이 순식간에 밝아진다.\", \"type\": \"narration\", \"index\": 10}, {\"text\": \"정말요? 헤헤… 그럼 제가 좋은 자리로 잡을게요!\", \"type\": \"dialogue\", \"index\": 11, \"speaker\": \"유자빈\"}, {\"text\": \"(이렇게 기뻐하는 걸 보니까… 괜히 나도 기분이 좋아지네.)\", \"type\": \"dialogue\", \"index\": 12, \"speaker\": \"나\"}, {\"text\": \"(나에게도… 드디어 사랑이 찾아오나…)\", \"type\": \"dialogue\", \"index\": 13, \"speaker\": \"나\"}, {\"type\": \"End\", \"index\": 14}]','유자빈 루트 엔딩',15),(15,'[{\"text\": \"발표가 끝나고 강의실을 나서려던 순간, 누군가 조심스레 내 옷자락을 잡는다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"선… 선배… 잠깐만요…\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"파인선\"}, {\"text\": \"뒤돌아보니 인선이 손끝을 모으고 서 있었다. 평소보다 더 얼굴이 빨갛다.\", \"type\": \"narration\", \"index\": 3}, {\"meta\": [{\"image\": \"/illust/python_end.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 4}, {\"text\": \"선배… 오늘 발표… 멋있었어요.\", \"type\": \"dialogue\", \"index\": 5, \"speaker\": \"파인선\"}, {\"text\": \"목소리는 여전히 작지만, 그 안에 담긴 용기만큼은 확실했다.\", \"type\": \"narration\", \"index\": 6}, {\"text\": \"저… 다음에 도서관에서… 또 같이 공부하면… 좋겠어요.\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"파인선\"}, {\"text\": \"그래. 약속.\", \"type\": \"dialogue\", \"index\": 8, \"speaker\": \"나\"}, {\"text\": \"인선은 놀란 듯 눈을 크게 뜨더니, 얼굴이 더 붉어져서는 천천히 고개를 끄덕인다.\", \"type\": \"narration\", \"index\": 9}, {\"text\": \"(나에게도 … 드디어 사랑이 찾아오나…)\", \"type\": \"dialogue\", \"index\": 10, \"speaker\": \"나\"}, {\"type\": \"End\", \"index\": 11}]','파인선 루트 엔딩',16),(16,'[{\"text\": \"수업이 끝나고 강의실을 정리하며 자리에서 일어섰다.\", \"type\": \"narration\", \"index\": 1}, {\"text\": \"(오늘 발표도 무사히 끝났고… 다들 정말 고생했지.)\", \"type\": \"dialogue\", \"index\": 2, \"speaker\": \"나\"}, {\"text\": \"혹시나 해서 주변을 둘러봤다. 방금까지 함께 있었던 팀원들을 찾아보며 조심스레 입을 열어보려 했다.\", \"type\": \"narration\", \"index\": 3}, {\"text\": \"저기… 혹시—\", \"type\": \"dialogue\", \"index\": 4, \"speaker\": \"나\"}, {\"meta\": [{\"image\": \"/illust/empty_classroom.png\", \"duration\": 3}], \"type\": \"illust\", \"index\": 5}, {\"text\": \"그러나 이미 강의실은 텅 비어 있었다.\", \"type\": \"narration\", \"index\": 6}, {\"text\": \"(…다들 바빴나보네. 인사라도 하고 싶었는데.)\", \"type\": \"dialogue\", \"index\": 7, \"speaker\": \"나\"}, {\"text\": \"커다란 강의실에서 혼자 서 있는 기분이 묘하게 쓸쓸하게 다가온다.\", \"type\": \"narration\", \"index\": 8}, {\"text\": \"(또다시… 혼자가 된 건가.)\", \"type\": \"dialogue\", \"index\": 9, \"speaker\": \"나\"}, {\"text\": \"(그래도… 나름 즐거웠던 시간이었지.)\", \"type\": \"dialogue\", \"index\": 10, \"speaker\": \"나\"}, {\"text\": \"(언젠가 또 이런 기회가 오려나… 아니면 이걸로 끝일까.)\", \"type\": \"dialogue\", \"index\": 11, \"speaker\": \"나\"}, {\"text\": \"창밖으로 저무는 노을이 강의실 바닥을 부드럽게 물들였다.\", \"type\": \"narration\", \"index\": 12}, {\"text\": \"(…뭐, 괜찮아. 오늘도 수고했다, 나.)\", \"type\": \"dialogue\", \"index\": 13, \"speaker\": \"나\"}, {\"type\": \"End\", \"index\": 14}]','노히로인 엔딩  다시 혼자가 된 주인공 (일러스트 포함)',17);
/*!40000 ALTER TABLE `script` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `story`
--

DROP TABLE IF EXISTS `story`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `story` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `storyCode` varchar(50) NOT NULL COMMENT '스토리 번호 (예: 1, 2-1, 2-2, 3-1)',
  `title` varchar(255) NOT NULL COMMENT '장 제목',
  `content` text COMMENT '장 내용 / 설명',
  `image` varchar(500) DEFAULT NULL COMMENT '배경 이미지 URL',
  PRIMARY KEY (`id`),
  UNIQUE KEY `storyCode` (`storyCode`),
  UNIQUE KEY `storyCode_2` (`storyCode`),
  UNIQUE KEY `storyCode_3` (`storyCode`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `story`
--

LOCK TABLES `story` WRITE;
/*!40000 ALTER TABLE `story` DISABLE KEYS */;
INSERT INTO `story` VALUES (1,'1','복학생 김철수의 시작','내 이름은 김철수. 스무 살에 입학했지만, 2년의 군 복무를 마치고 돌아오니 어느새 스물셋 복학생이 되어버렸다. 전공은 소프트웨어공학과...','/background/intro.png'),(2,'2','그녀들과의 첫만남','웹시설에서만난 3명의 히로인 그들과의 조별과제가 시작된다','/background/class.png'),(3,'3','다음 수업으로 향하는 복학생 김철수','다음수업으로 향하는 복학생 김철수와 세 히로인','/background/class.png'),(4,'4','시현과의 첫 수업','시현과의 첫 수업 중 친해지는','/background/class.png'),(5,'5','자빈과의 첫 수업','자빈과의 첫 수업 중 친해지는','/background/class.png'),(6,'6','인선과의 첫 수업','인선과의 첫 수업 중 친해지는','/background/class.png'),(7,'7','시현과의 첫 식사','시현과의 첫 식사 중 친해지는','/background/cafeteria.png'),(8,'8','자빈과의 첫 동아리방','자빈과의 첫 동아리방에서 친해지는','/background/clubroom.png'),(9,'9','자빈과의 첫 동아리방','자빈과의 첫 동아리방에서 친해지는','/background/library.png'),(10,'10','마지막 조별과제','조별과제 마지막 준비 카페에서의 최종 점검','/background/cafe.png'),(11,'11','마지막 발표','조별과제 마지막 발표날','/background/class.png'),(12,'12','엔딩 전','엔딩 마지막','/background/class.png'),(14,'13','시현엔딩','시현엔딩','/background/class.png'),(15,'14','자빈엔딩','자빈엔딩','/background/class.png'),(16,'15','파인선엔딩','파인선엔딩','/background/class.png'),(17,'16','노히로인엔딩','노히로인엔딩','/background/class.png');
/*!40000 ALTER TABLE `story` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `story_heroine`
--

DROP TABLE IF EXISTS `story_heroine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `story_heroine` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `storyId` bigint unsigned NOT NULL,
  `heroineId` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `story_heroine_heroineId_storyId_unique` (`storyId`,`heroineId`),
  KEY `heroineId` (`heroineId`),
  CONSTRAINT `story_heroine_ibfk_5` FOREIGN KEY (`storyId`) REFERENCES `story` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `story_heroine_ibfk_6` FOREIGN KEY (`heroineId`) REFERENCES `heroine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `story_heroine`
--

LOCK TABLES `story_heroine` WRITE;
/*!40000 ALTER TABLE `story_heroine` DISABLE KEYS */;
INSERT INTO `story_heroine` VALUES (1,2,1),(2,2,2),(3,2,3),(4,3,1),(5,3,2),(6,3,3),(7,4,1),(8,5,2),(9,6,3),(10,7,1),(11,8,2),(12,9,3),(13,10,1),(14,10,2),(15,10,3),(16,11,1),(17,11,2),(18,11,3),(22,12,1),(23,12,2),(24,12,3),(25,14,1),(26,15,2),(27,16,3);
/*!40000 ALTER TABLE `story_heroine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `story_problems`
--

DROP TABLE IF EXISTS `story_problems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `story_problems` (
  `story_id` bigint unsigned NOT NULL,
  `problem_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`story_id`,`problem_id`),
  UNIQUE KEY `story_problems_problemId_storyId_unique` (`story_id`,`problem_id`),
  KEY `problem_id` (`problem_id`),
  CONSTRAINT `story_problems_ibfk_1` FOREIGN KEY (`story_id`) REFERENCES `story` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `story_problems_ibfk_2` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `story_problems`
--

LOCK TABLES `story_problems` WRITE;
/*!40000 ALTER TABLE `story_problems` DISABLE KEYS */;
INSERT INTO `story_problems` VALUES (4,1),(5,1),(6,1),(7,2),(8,2),(9,2);
/*!40000 ALTER TABLE `story_problems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testcase`
--

DROP TABLE IF EXISTS `testcase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `testcase` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `content` text,
  `input` text,
  `expected` text,
  `problem_id` bigint unsigned DEFAULT NULL,
  `order` int DEFAULT '0',
  `is_public` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `problem_id` (`problem_id`),
  CONSTRAINT `testcase_ibfk_1` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testcase`
--

LOCK TABLES `testcase` WRITE;
/*!40000 ALTER TABLE `testcase` DISABLE KEYS */;
INSERT INTO `testcase` VALUES (1,'기본 테스트','1 2','3',1,1,1),(2,'두 자리 수 테스트','10 20','30',1,2,1),(3,'음수 포함 테스트','-5 7','2',1,3,0),(4,'기본 테스트','2 3','6',2,1,1),(5,'두 자리 수 테스트','10 20','200',2,2,1),(6,'음수 포함 테스트','-5 7','-35',2,3,0);
/*!40000 ALTER TABLE `testcase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_code`
--

DROP TABLE IF EXISTS `user_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_code` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `problem_id` bigint unsigned DEFAULT NULL,
  `code` text,
  `content` text,
  `is_pass` tinyint(1) DEFAULT '0',
  `stdout` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `problem_id` (`problem_id`),
  CONSTRAINT `user_code_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `user_code_ibfk_6` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_code`
--

LOCK TABLES `user_code` WRITE;
/*!40000 ALTER TABLE `user_code` DISABLE KEYS */;
INSERT INTO `user_code` VALUES (1,'4c8beb47-874b-40c6-bafb-bcf1eefa18ef',1,'loop(1)','\n---\n\n---\n',0,'\n---\n\n---\n',NULL,NULL),(2,'4c8beb47-874b-40c6-bafb-bcf1eefa18ef',2,'loop(1)','\n---\n\n---\n',0,'\n---\n\n---\n',NULL,NULL),(3,'4c8beb47-874b-40c6-bafb-bcf1eefa18ef',1,'ㅇ','\n---\n\n---\n',0,'\n---\n\n---\n',NULL,NULL),(4,'4c8beb47-874b-40c6-bafb-bcf1eefa18ef',2,'ㅇ','\n---\n\n---\n',0,'\n---\n\n---\n',NULL,NULL),(5,'4c8beb47-874b-40c6-bafb-bcf1eefa18ef',1,'ㅇ','\n---\n\n---\n',0,'\n---\n\n---\n',NULL,NULL),(6,'4c8beb47-874b-40c6-bafb-bcf1eefa18ef',2,'ㅇㅇ','\n---\n\n---\n',0,'\n---\n\n---\n',NULL,NULL);
/*!40000 ALTER TABLE `user_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `nickname` varchar(30) DEFAULT NULL,
  `snsId` varchar(100) DEFAULT NULL,
  `provider` varchar(20) DEFAULT NULL,
  `refreshToken` text,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `email_2` (`email`),
  UNIQUE KEY `email_3` (`email`),
  UNIQUE KEY `email_4` (`email`),
  UNIQUE KEY `email_5` (`email`),
  UNIQUE KEY `email_6` (`email`),
  UNIQUE KEY `email_7` (`email`),
  UNIQUE KEY `email_8` (`email`),
  UNIQUE KEY `nickname` (`nickname`),
  UNIQUE KEY `nickname_2` (`nickname`),
  UNIQUE KEY `nickname_3` (`nickname`),
  UNIQUE KEY `nickname_4` (`nickname`),
  UNIQUE KEY `nickname_5` (`nickname`),
  UNIQUE KEY `nickname_6` (`nickname`),
  UNIQUE KEY `nickname_7` (`nickname`),
  UNIQUE KEY `nickname_8` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('4c8beb47-874b-40c6-bafb-bcf1eefa18ef','samajk495545@ajou.ac.kr','$2b$10$iECDE0CptlnFpY/Z0Yzajecn5hq3Hjgyp91pjCrpYr2FR0ypWfCRy','안재관',NULL,NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjRjOGJlYjQ3LTg3NGItNDBjNi1iYWZiLWJjZjFlZWZhMThlZiIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzY1MjU1OTg5LCJleHAiOjE3NjU4NjA3ODl9.xrMukOHV9XcqeP9zwbOVqrSvacT0dKIPkqh6QU-lQHA','2025-12-08 18:53:30','2025-12-09 13:53:09');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'love_world'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-09  5:03:51
