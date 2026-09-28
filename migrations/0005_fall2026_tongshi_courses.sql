-- 2026 秋季 通识课 — imported from the university course list (通识课.docx).
--
-- New course fields:
--   courses.tongshi  通识课一 / 二 / 三 / 四 (the 通识课 type), or NULL
--   courses.is_core  1 = 通识核心课, 0 = 通选课
-- A course can be 与中国有关课程 AND a 通识课 at the same time: its category
-- stays 与中国有关课程 and tongshi says which 通识课 type it also counts as.
--
-- * Rows without a type (plain 通选课 / 劳动教育课 without I–IV) are skipped:
--   创新与快速原型研制, 医学通识：信息时代的健康素养, 微电子学概论, 文献写作与报告,
--   电子工程实训, 连接世界的通信.
-- * Same name + several teachers → one course with several teacher options.
-- * 政治学原理 is two different courses (核心课 3 学分 / 通选课 2 学分), so the
--   second one is named 政治学原理（通选课）.
-- * 11 courses were already on the site (from the 与中国有关课程 list); they
--   keep their category and just get their 通识课 type.
-- * Applied once by `npm run db:migrate` (it adds two columns).

ALTER TABLE courses ADD COLUMN tongshi TEXT;
ALTER TABLE courses ADD COLUMN is_core INTEGER NOT NULL DEFAULT 0;

-- Courses already filed under a 通识课 category.
UPDATE courses SET tongshi = category WHERE category IN ('通识课一', '通识课二', '通识课三', '通识课四');


-- 国外社会学学说（下） · 通识课二 · 核心课 · 03130020 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '国外社会学学说（下）', '李康', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '国外社会学学说（下）');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '国外社会学学说（下）' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李康' FROM courses WHERE name_cn = '国外社会学学说（下）' HAVING MIN(id) IS NOT NULL;

-- 社会发展理论 · 通识课二 · 核心课 · 04031000 马克思主义学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '社会发展理论', '孙超', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '社会发展理论');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '社会发展理论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '孙超' FROM courses WHERE name_cn = '社会发展理论' HAVING MIN(id) IS NOT NULL;

-- 印度佛教史 · 通识课一 · 02332013 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '印度佛教史', '赵悠', 2, '秋季', '通识课一', '通识课一', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '印度佛教史');
UPDATE courses SET tongshi = '通识课一', is_core = 0 WHERE name_cn = '印度佛教史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '赵悠' FROM courses WHERE name_cn = '印度佛教史' HAVING MIN(id) IS NOT NULL;

-- 大气概论 · 通识课四 · 00432270 物理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '大气概论', '李万彪', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '大气概论');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '大气概论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李万彪' FROM courses WHERE name_cn = '大气概论' HAVING MIN(id) IS NOT NULL;

-- 地球与人类文明 · 通识课四 · 核心课 · 01230410 地球与空间科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '地球与人类文明', '陈斌、郭艳军', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '地球与人类文明');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '地球与人类文明' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陈斌、郭艳军' FROM courses WHERE name_cn = '地球与人类文明' HAVING MIN(id) IS NOT NULL;

-- 普通生物学（B） · 通识课四 · 核心课 · 01139380 生命科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '普通生物学（B）', '佟向军', 3, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '普通生物学（B）');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '普通生物学（B）' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '佟向军' FROM courses WHERE name_cn = '普通生物学（B）' HAVING MIN(id) IS NOT NULL;

-- 人类的性、生育与健康 · 通识课四 · 01130871 生命科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '人类的性、生育与健康', '姚锦仙', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '人类的性、生育与健康');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '人类的性、生育与健康' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '姚锦仙' FROM courses WHERE name_cn = '人类的性、生育与健康' HAVING MIN(id) IS NOT NULL;

-- 现代主义音乐：挑战与挑衅 · 通识课三 · 04331301 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '现代主义音乐：挑战与挑衅', '刘彦玲', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '现代主义音乐：挑战与挑衅');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '现代主义音乐：挑战与挑衅' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘彦玲' FROM courses WHERE name_cn = '现代主义音乐：挑战与挑衅' HAVING MIN(id) IS NOT NULL;

-- 传播学理论 · 通识课二 · 核心课 · 01834200 新闻与传播学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '传播学理论', '王洪喆', 3, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '传播学理论');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '传播学理论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王洪喆' FROM courses WHERE name_cn = '传播学理论' HAVING MIN(id) IS NOT NULL;

-- 经济学原理（Ⅰ） · 通识课二 · 02533160 经济学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '经济学原理（Ⅰ）', '田巍', 3, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '经济学原理（Ⅰ）');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '经济学原理（Ⅰ）' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '田巍' FROM courses WHERE name_cn = '经济学原理（Ⅰ）' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '胡涛' FROM courses WHERE name_cn = '经济学原理（Ⅰ）' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴泽南' FROM courses WHERE name_cn = '经济学原理（Ⅰ）' HAVING MIN(id) IS NOT NULL;

-- 政治学原理 · 通识课二 · 核心课 · 03230020 政府管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '政治学原理', '马啸', 3, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '政治学原理');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '政治学原理' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '马啸' FROM courses WHERE name_cn = '政治学原理' HAVING MIN(id) IS NOT NULL;

-- 政治学原理（通选课） · 通识课二 · 03230900 政府管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '政治学原理（通选课）', '马啸、刘舒杨、彭莹莹', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '政治学原理（通选课）');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '政治学原理（通选课）' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '马啸、刘舒杨、彭莹莹' FROM courses WHERE name_cn = '政治学原理（通选课）' HAVING MIN(id) IS NOT NULL;

-- 魅力化学 · 通识课四 · 01034030 化学与分子工程学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '魅力化学', '黄建滨', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '魅力化学');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '魅力化学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '黄建滨' FROM courses WHERE name_cn = '魅力化学' HAVING MIN(id) IS NOT NULL;

-- 传统太极拳：哲学与实践 · 通识课一 · 02319642 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '传统太极拳：哲学与实践', '朱效民', 2, '秋季', '通识课一', '通识课一', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '传统太极拳：哲学与实践');
UPDATE courses SET tongshi = '通识课一', is_core = 0 WHERE name_cn = '传统太极拳：哲学与实践' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '朱效民' FROM courses WHERE name_cn = '传统太极拳：哲学与实践' HAVING MIN(id) IS NOT NULL;

-- 创新创业家精神培育和实验 · 通识课二 · 02535430 经济学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '创新创业家精神培育和实验', '章政', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '创新创业家精神培育和实验');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '创新创业家精神培育和实验' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '章政' FROM courses WHERE name_cn = '创新创业家精神培育和实验' HAVING MIN(id) IS NOT NULL;

-- 大学化学 · 通识课四 · 01034060 化学与分子工程学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '大学化学', '卞祖强', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '大学化学');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '大学化学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '卞祖强' FROM courses WHERE name_cn = '大学化学' HAVING MIN(id) IS NOT NULL;

-- 当代环境科学 · 通识课四 · 核心课 · 12731080 环境科学与工程学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '当代环境科学', '刘建国', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '当代环境科学');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '当代环境科学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘建国' FROM courses WHERE name_cn = '当代环境科学' HAVING MIN(id) IS NOT NULL;

-- 电子游戏改造人类世界的历史 · 通识课二 · 08430003 前沿交叉学科研究院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '电子游戏改造人类世界的历史', '曹琪', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '电子游戏改造人类世界的历史');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '电子游戏改造人类世界的历史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '曹琪' FROM courses WHERE name_cn = '电子游戏改造人类世界的历史' HAVING MIN(id) IS NOT NULL;

-- 犯罪通论 · 通识课二 · 02930905 法学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '犯罪通论', '梁根林', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '犯罪通论');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '犯罪通论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '梁根林' FROM courses WHERE name_cn = '犯罪通论' HAVING MIN(id) IS NOT NULL;

-- 国际贸易政治学 · 通识课二 · 核心课 · 02433050 国际关系学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '国际贸易政治学', '王勇', 3, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '国际贸易政治学');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '国际贸易政治学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王勇' FROM courses WHERE name_cn = '国际贸易政治学' HAVING MIN(id) IS NOT NULL;

-- 简明量子力学 · 通识课四 · 核心课 · 00433331 物理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '简明量子力学', '吴飙', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '简明量子力学');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '简明量子力学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴飙' FROM courses WHERE name_cn = '简明量子力学' HAVING MIN(id) IS NOT NULL;

-- 经济学原理 · 通识课二 · 核心课 · 06232000 国家发展研究院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '经济学原理', '张维迎', 4, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '经济学原理');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '经济学原理' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张维迎' FROM courses WHERE name_cn = '经济学原理' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '汪浩' FROM courses WHERE name_cn = '经济学原理' HAVING MIN(id) IS NOT NULL;

-- 明清经济与社会 · 通识课二 · 核心课 · 02138870 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '明清经济与社会', '毛亦可', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '明清经济与社会');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '明清经济与社会' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '毛亦可' FROM courses WHERE name_cn = '明清经济与社会' HAVING MIN(id) IS NOT NULL;

-- 生态学导论：生存博弈与人类行为 · 通识课四 · 核心课 · 12632260 城市与环境学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '生态学导论：生存博弈与人类行为', '王娓', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '生态学导论：生存博弈与人类行为');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '生态学导论：生存博弈与人类行为' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王娓' FROM courses WHERE name_cn = '生态学导论：生存博弈与人类行为' HAVING MIN(id) IS NOT NULL;

-- 音乐与数学 · 通识课三 · 核心课 · 00137975 数学科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '音乐与数学', '王杰', 3, '秋季', '通识课三', '通识课三', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '音乐与数学');
UPDATE courses SET tongshi = '通识课三', is_core = 1 WHERE name_cn = '音乐与数学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王杰' FROM courses WHERE name_cn = '音乐与数学' HAVING MIN(id) IS NOT NULL;

-- 中共党史专题 · 通识课二 · 02132990 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中共党史专题', '黄道炫', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中共党史专题');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '中共党史专题' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '黄道炫' FROM courses WHERE name_cn = '中共党史专题' HAVING MIN(id) IS NOT NULL;

-- 自然保护：思想与实践 · 通识课四 · 核心课 · 01130961 生命科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '自然保护：思想与实践', '吕植、王昊', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '自然保护：思想与实践');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '自然保护：思想与实践' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吕植、王昊' FROM courses WHERE name_cn = '自然保护：思想与实践' HAVING MIN(id) IS NOT NULL;

-- 人类沟通的起源与发展 · 通识课一 · 02033870 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '人类沟通的起源与发展', '汪锋', 2, '秋季', '通识课一', '通识课一', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '人类沟通的起源与发展');
UPDATE courses SET tongshi = '通识课一', is_core = 0 WHERE name_cn = '人类沟通的起源与发展' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '汪锋' FROM courses WHERE name_cn = '人类沟通的起源与发展' HAVING MIN(id) IS NOT NULL;

-- 数值方法：原理，算法及应用 · 通识课四 · 核心课 · 00136540 数学科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '数值方法：原理，算法及应用', '卢朓', 3, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '数值方法：原理，算法及应用');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '数值方法：原理，算法及应用' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '卢朓' FROM courses WHERE name_cn = '数值方法：原理，算法及应用' HAVING MIN(id) IS NOT NULL;

-- 演示物理学 · 通识课四 · 核心课 · 00430109 物理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '演示物理学', '李湘庆', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '演示物理学');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '演示物理学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李湘庆' FROM courses WHERE name_cn = '演示物理学' HAVING MIN(id) IS NOT NULL;

-- 媒体与社会 · 通识课二 · 核心课 · 03032170 信息管理系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '媒体与社会', '闫蒲', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '媒体与社会');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '媒体与社会' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '闫蒲' FROM courses WHERE name_cn = '媒体与社会' HAVING MIN(id) IS NOT NULL;

-- 实验心理学 · 通识课四 · 核心课 · 01630034 心理与认知科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '实验心理学', '吴艳红、耿海燕、张俊云', 4, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '实验心理学');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '实验心理学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴艳红、耿海燕、张俊云' FROM courses WHERE name_cn = '实验心理学' HAVING MIN(id) IS NOT NULL;

-- 支配与社会：马克思·韦伯的《经济与社会》 · 通识课二 · 核心课 · 03111400 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '支配与社会：马克思·韦伯的《经济与社会》', '田耕', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '支配与社会：马克思·韦伯的《经济与社会》');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '支配与社会：马克思·韦伯的《经济与社会》' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '田耕' FROM courses WHERE name_cn = '支配与社会：马克思·韦伯的《经济与社会》' HAVING MIN(id) IS NOT NULL;

-- 中国古代文化 · 通识课一 · 核心课 · 02031540 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中国古代文化', '杜以恒', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代文化');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '中国古代文化' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '杜以恒' FROM courses WHERE name_cn = '中国古代文化' HAVING MIN(id) IS NOT NULL;

-- 大学国文 · 通识课三 · 核心课 · 02034300 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '大学国文', '王风', 2, '秋季', '通识课三', '通识课三', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '大学国文');
UPDATE courses SET tongshi = '通识课三', is_core = 1 WHERE name_cn = '大学国文' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王风' FROM courses WHERE name_cn = '大学国文' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '白一瑾' FROM courses WHERE name_cn = '大学国文' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '胡琦' FROM courses WHERE name_cn = '大学国文' HAVING MIN(id) IS NOT NULL;

-- 化学与社会 · 通识课四 · 核心课 · 01034040 化学与分子工程学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '化学与社会', '卞江', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '化学与社会');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '化学与社会' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '卞江' FROM courses WHERE name_cn = '化学与社会' HAVING MIN(id) IS NOT NULL;

-- 跨文化交流学 · 通识课二 · 01831990 新闻与传播学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '跨文化交流学', '欧梦雪', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '跨文化交流学');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '跨文化交流学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '欧梦雪' FROM courses WHERE name_cn = '跨文化交流学' HAVING MIN(id) IS NOT NULL;

-- 葡萄酒背后的科学与文化 · 通识课三 · 01132688 生命科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '葡萄酒背后的科学与文化', '彭宜本', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '葡萄酒背后的科学与文化');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '葡萄酒背后的科学与文化' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '彭宜本' FROM courses WHERE name_cn = '葡萄酒背后的科学与文化' HAVING MIN(id) IS NOT NULL;

-- 人际关系与健康心理 · 通识课二 · 01630758 心理与认知科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '人际关系与健康心理', '姚翔', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '人际关系与健康心理');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '人际关系与健康心理' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '姚翔' FROM courses WHERE name_cn = '人际关系与健康心理' HAVING MIN(id) IS NOT NULL;

-- 数据科学导引C · 通识课四 · 03034040 信息管理系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '数据科学导引C', '黄文彬、步一、孟凡', 3, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '数据科学导引C');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '数据科学导引C' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '黄文彬、步一、孟凡' FROM courses WHERE name_cn = '数据科学导引C' HAVING MIN(id) IS NOT NULL;

-- 微观经济学 · 通识课二 · 02530060, 02838360 光华管理学院, 经济学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '微观经济学', '李法强', 3, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '微观经济学');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '微观经济学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李法强' FROM courses WHERE name_cn = '微观经济学' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '高彧' FROM courses WHERE name_cn = '微观经济学' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李绍荣' FROM courses WHERE name_cn = '微观经济学' HAVING MIN(id) IS NOT NULL;

-- 舞蹈理论与实践 · 通识课三 · 04334000 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '舞蹈理论与实践', '佟佳家', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '舞蹈理论与实践');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '舞蹈理论与实践' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '佟佳家' FROM courses WHERE name_cn = '舞蹈理论与实践' HAVING MIN(id) IS NOT NULL;

-- 哲学导论 · 通识课一 · 核心课 · 02330003 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '哲学导论', '李麒麟、赵新侃、赵斌、闫琦琛等', 3, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '哲学导论');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '哲学导论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李麒麟、赵新侃、赵斌、闫琦琛等' FROM courses WHERE name_cn = '哲学导论' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李猛' FROM courses WHERE name_cn = '哲学导论' HAVING MIN(id) IS NOT NULL;

-- 中俄文化交流史 · 通识课三 · 03730740 外国语学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中俄文化交流史', '查晓燕', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中俄文化交流史');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '中俄文化交流史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '查晓燕' FROM courses WHERE name_cn = '中俄文化交流史' HAVING MIN(id) IS NOT NULL;

-- 环境材料导论 · 通识课四 · 12731050 环境科学与工程学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '环境材料导论', '刘文', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '环境材料导论');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '环境材料导论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘文' FROM courses WHERE name_cn = '环境材料导论' HAVING MIN(id) IS NOT NULL;

-- 生物进化论 · 通识课四 · 核心课 · 01130780 生命科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '生物进化论', '张蔚、遇赫、姚蒙', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '生物进化论');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '生物进化论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张蔚、遇赫、姚蒙' FROM courses WHERE name_cn = '生物进化论' HAVING MIN(id) IS NOT NULL;

-- 坛经 · 通识课一 · 核心课 · 02332323 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '坛经', '周学农', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '坛经');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '坛经' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '周学农' FROM courses WHERE name_cn = '坛经' HAVING MIN(id) IS NOT NULL;

-- 政治分析中的重大问题 · 通识课二 · 核心课 · 03233160 政府管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '政治分析中的重大问题', '刘颜俊', 3, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '政治分析中的重大问题');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '政治分析中的重大问题' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘颜俊' FROM courses WHERE name_cn = '政治分析中的重大问题' HAVING MIN(id) IS NOT NULL;

-- 北京历史地理 · 通识课一 · 12634190 城市与环境学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '北京历史地理', '王长松', 2, '秋季', '通识课一', '通识课一', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '北京历史地理');
UPDATE courses SET tongshi = '通识课一', is_core = 0 WHERE name_cn = '北京历史地理' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王长松' FROM courses WHERE name_cn = '北京历史地理' HAVING MIN(id) IS NOT NULL;

-- 传记文学：经典人物研究 · 通识课三 · 03634030 外国语学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '传记文学：经典人物研究', '赵白生', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '传记文学：经典人物研究');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '传记文学：经典人物研究' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '赵白生' FROM courses WHERE name_cn = '传记文学：经典人物研究' HAVING MIN(id) IS NOT NULL;

-- 当代科技史 · 通识课四 · 08430001 前沿交叉学科研究院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '当代科技史', '曹琪、张藜', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '当代科技史');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '当代科技史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '曹琪、张藜' FROM courses WHERE name_cn = '当代科技史' HAVING MIN(id) IS NOT NULL;

-- 地球历史概要 · 通识课四 · 01231210 地球与空间科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '地球历史概要', '刘建波', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '地球历史概要');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '地球历史概要' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘建波' FROM courses WHERE name_cn = '地球历史概要' HAVING MIN(id) IS NOT NULL;

-- 广告学概论 · 通识课二 · 01830480 新闻与传播学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '广告学概论', '陈刚', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '广告学概论');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '广告学概论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陈刚' FROM courses WHERE name_cn = '广告学概论' HAVING MIN(id) IS NOT NULL;

-- 矿产资源经济概论 · 通识课四 · 核心课 · 01231130 地球与空间科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '矿产资源经济概论', '朱永峰', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '矿产资源经济概论');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '矿产资源经济概论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '朱永峰' FROM courses WHERE name_cn = '矿产资源经济概论' HAVING MIN(id) IS NOT NULL;

-- 孟子哲学 · 通识课一 · 核心课 · 02335201 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '孟子哲学', '白辉洪', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '孟子哲学');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '孟子哲学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '白辉洪' FROM courses WHERE name_cn = '孟子哲学' HAVING MIN(id) IS NOT NULL;

-- 欧洲风土记 · 通识课二 · 03132090 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '欧洲风土记', '张帆', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '欧洲风土记');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '欧洲风土记' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张帆' FROM courses WHERE name_cn = '欧洲风土记' HAVING MIN(id) IS NOT NULL;

-- 社会研究：经典与方法 · 通识课二 · 核心课 · 03130903 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '社会研究：经典与方法', '渠敬东', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '社会研究：经典与方法');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '社会研究：经典与方法' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '渠敬东' FROM courses WHERE name_cn = '社会研究：经典与方法' HAVING MIN(id) IS NOT NULL;

-- 狭义相对论与时空观 · 通识课四 · 00433340 物理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '狭义相对论与时空观', '邵立晶', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '狭义相对论与时空观');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '狭义相对论与时空观' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '邵立晶' FROM courses WHERE name_cn = '狭义相对论与时空观' HAVING MIN(id) IS NOT NULL;

-- 心理学导论 · 通识课四 · 核心课 · 01630079 心理与认知科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '心理学导论', '毛利华', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '心理学导论');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '心理学导论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '毛利华' FROM courses WHERE name_cn = '心理学导论' HAVING MIN(id) IS NOT NULL;

-- 中国传统官僚政治制度 · 通识课一 · 核心课 · 02131310 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中国传统官僚政治制度', '叶炜', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国传统官僚政治制度');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '中国传统官僚政治制度' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '叶炜' FROM courses WHERE name_cn = '中国传统官僚政治制度' HAVING MIN(id) IS NOT NULL;

-- 中国通史（古代部分） · 通识课一 · 02132750 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中国通史（古代部分）', '陈侃理', 2, '秋季', '通识课一', '通识课一', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国通史（古代部分）');
UPDATE courses SET tongshi = '通识课一', is_core = 0 WHERE name_cn = '中国通史（古代部分）' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陈侃理' FROM courses WHERE name_cn = '中国通史（古代部分）' HAVING MIN(id) IS NOT NULL;

-- 走近中国书法 · 通识课三 · 04331302 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '走近中国书法', '祝帅', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '走近中国书法');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '走近中国书法' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '祝帅' FROM courses WHERE name_cn = '走近中国书法' HAVING MIN(id) IS NOT NULL;

-- 公共组织行为学 · 通识课二 · 核心课 · 03232460 政府管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '公共组织行为学', '田凯', 3, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '公共组织行为学');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '公共组织行为学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '田凯' FROM courses WHERE name_cn = '公共组织行为学' HAVING MIN(id) IS NOT NULL;

-- 普通统计学 · 通识课四 · 核心课 · 00136700 数学科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '普通统计学', '艾明要', 3, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '普通统计学');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '普通统计学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '艾明要' FROM courses WHERE name_cn = '普通统计学' HAVING MIN(id) IS NOT NULL;

-- 社会科学方法导论 · 通识课二 · 核心课 · 03130906 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '社会科学方法导论', '乔天宇、严洁、陈斌、王洪喆等', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '社会科学方法导论');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '社会科学方法导论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '乔天宇、严洁、陈斌、王洪喆等' FROM courses WHERE name_cn = '社会科学方法导论' HAVING MIN(id) IS NOT NULL;

-- 现代天文学 · 通识课四 · 核心课 · 00432265 物理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '现代天文学', '王科', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '现代天文学');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '现代天文学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王科' FROM courses WHERE name_cn = '现代天文学' HAVING MIN(id) IS NOT NULL;

-- 组织管理心理学 · 通识课二 · 01630600 心理与认知科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '组织管理心理学', '李圭泉', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '组织管理心理学');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '组织管理心理学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李圭泉' FROM courses WHERE name_cn = '组织管理心理学' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '姚翔' FROM courses WHERE name_cn = '组织管理心理学' HAVING MIN(id) IS NOT NULL;

-- 国外社会学学说（上） · 通识课二 · 核心课 · 03100130 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '国外社会学学说（上）', '孙飞宇', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '国外社会学学说（上）');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '国外社会学学说（上）' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '孙飞宇' FROM courses WHERE name_cn = '国外社会学学说（上）' HAVING MIN(id) IS NOT NULL;

-- 汉语修辞学 · 通识课三 · 01831610 新闻与传播学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '汉语修辞学', '陈汝东', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '汉语修辞学');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '汉语修辞学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陈汝东' FROM courses WHERE name_cn = '汉语修辞学' HAVING MIN(id) IS NOT NULL;

-- 普通生物学（C） · 通识课四 · 01139350 生命科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '普通生物学（C）', '罗述金', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '普通生物学（C）');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '普通生物学（C）' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '罗述金' FROM courses WHERE name_cn = '普通生物学（C）' HAVING MIN(id) IS NOT NULL;

-- 西方文明史导论 · 通识课一 · 02131250 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '西方文明史导论', '李隆国', 2, '秋季', '通识课一', '通识课一', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '西方文明史导论');
UPDATE courses SET tongshi = '通识课一', is_core = 0 WHERE name_cn = '西方文明史导论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李隆国' FROM courses WHERE name_cn = '西方文明史导论' HAVING MIN(id) IS NOT NULL;

-- 中国当代法律和社会 · 通识课二 · 核心课 · 02930187 法学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中国当代法律和社会', '彭錞', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国当代法律和社会');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '中国当代法律和社会' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '彭錞' FROM courses WHERE name_cn = '中国当代法律和社会' HAVING MIN(id) IS NOT NULL;

-- 东西方民间文学 · 通识课三 · 03531900 外国语学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '东西方民间文学', '陈岗龙、沙筱薇、陈飞、史阳等', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '东西方民间文学');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '东西方民间文学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陈岗龙、沙筱薇、陈飞、史阳等' FROM courses WHERE name_cn = '东西方民间文学' HAVING MIN(id) IS NOT NULL;

-- 宏观经济学 · 通识课二 · 02530070 经济学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '宏观经济学', '苏剑', 3, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '宏观经济学');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '宏观经济学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '苏剑' FROM courses WHERE name_cn = '宏观经济学' HAVING MIN(id) IS NOT NULL;

-- 教育社会学思考 · 通识课二 · 03130400 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '教育社会学思考', '张春泥', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '教育社会学思考');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '教育社会学思考' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张春泥' FROM courses WHERE name_cn = '教育社会学思考' HAVING MIN(id) IS NOT NULL;

-- 可持续校园实践 · 通识课二 · 12730170 环境科学与工程学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '可持续校园实践', '韩凌', 3, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '可持续校园实践');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '可持续校园实践' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '韩凌' FROM courses WHERE name_cn = '可持续校园实践' HAVING MIN(id) IS NOT NULL;

-- 数智社会 · 通识课二 · 03132270 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '数智社会', '邱泽奇', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '数智社会');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '数智社会' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '邱泽奇' FROM courses WHERE name_cn = '数智社会' HAVING MIN(id) IS NOT NULL;

-- 外国经济史 · 通识课二 · 02530160 经济学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '外国经济史', '刘群艺', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '外国经济史');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '外国经济史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘群艺' FROM courses WHERE name_cn = '外国经济史' HAVING MIN(id) IS NOT NULL;

-- 博弈论 · 通识课二 · 03232480 政府管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '博弈论', '刘霖', 3, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '博弈论');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '博弈论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘霖' FROM courses WHERE name_cn = '博弈论' HAVING MIN(id) IS NOT NULL;

-- 分析哲学概论 · 通识课一 · 02333100 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '分析哲学概论', '李麒麟', 2, '秋季', '通识课一', '通识课一', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '分析哲学概论');
UPDATE courses SET tongshi = '通识课一', is_core = 0 WHERE name_cn = '分析哲学概论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李麒麟' FROM courses WHERE name_cn = '分析哲学概论' HAVING MIN(id) IS NOT NULL;

-- 公法与思想史 · 通识课二 · 核心课 · 02930188 法学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '公法与思想史', '章永乐', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '公法与思想史');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '公法与思想史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '章永乐' FROM courses WHERE name_cn = '公法与思想史' HAVING MIN(id) IS NOT NULL;

-- 美国环境思想 · 通识课二 · 02330501 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '美国环境思想', '苏贤贵', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '美国环境思想');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '美国环境思想' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '苏贤贵' FROM courses WHERE name_cn = '美国环境思想' HAVING MIN(id) IS NOT NULL;

-- 民主的历史与现实 · 通识课二 · 核心课 · 02432210 国际关系学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '民主的历史与现实', '汪卫华', 3, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '民主的历史与现实');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '民主的历史与现实' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '汪卫华' FROM courses WHERE name_cn = '民主的历史与现实' HAVING MIN(id) IS NOT NULL;

-- 普通心理学 · 通识课四 · 核心课 · 01630900 心理与认知科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '普通心理学', '方方、苏彦捷、毛利华、姚翔等', 4, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '普通心理学');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '普通心理学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '方方、苏彦捷、毛利华、姚翔等' FROM courses WHERE name_cn = '普通心理学' HAVING MIN(id) IS NOT NULL;

-- 人类学导论 · 通识课二 · 核心课 · 03130940 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '人类学导论', '林叶', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '人类学导论');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '人类学导论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '林叶' FROM courses WHERE name_cn = '人类学导论' HAVING MIN(id) IS NOT NULL;

-- 社会调查研究方法 · 通识课二 · 核心课 · 04031314 马克思主义学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '社会调查研究方法', '焦长权', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '社会调查研究方法');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '社会调查研究方法' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '焦长权' FROM courses WHERE name_cn = '社会调查研究方法' HAVING MIN(id) IS NOT NULL;

-- 社会心理学（B） · 通识课二 · 01630727 心理与认知科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '社会心理学（B）', '侯玉波', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '社会心理学（B）');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '社会心理学（B）' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '侯玉波' FROM courses WHERE name_cn = '社会心理学（B）' HAVING MIN(id) IS NOT NULL;

-- 生活中的心理学 · 通识课四 · 01635020 心理与认知科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '生活中的心理学', '方新、张楚佳', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '生活中的心理学');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '生活中的心理学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '方新、张楚佳' FROM courses WHERE name_cn = '生活中的心理学' HAVING MIN(id) IS NOT NULL;

-- 世界文化地理 · 通识课四 · 核心课 · 01339180 城市与环境学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '世界文化地理', '邓辉', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '世界文化地理');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '世界文化地理' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '邓辉' FROM courses WHERE name_cn = '世界文化地理' HAVING MIN(id) IS NOT NULL;

-- 数据科学导引B · 通识课四 · 08430008 前沿交叉学科研究院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '数据科学导引B', '张文涛', 3, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '数据科学导引B');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '数据科学导引B' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张文涛' FROM courses WHERE name_cn = '数据科学导引B' HAVING MIN(id) IS NOT NULL;

-- 中华民族共同体概论 · 通识课二 · 03132220 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中华民族共同体概论', '王娟、党宝海、张哲、单嗣平等', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中华民族共同体概论');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '中华民族共同体概论' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王娟、党宝海、张哲、单嗣平等' FROM courses WHERE name_cn = '中华民族共同体概论' HAVING MIN(id) IS NOT NULL;

-- 中美关系史 · 通识课一 · 02131580 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中美关系史', '张静', 2, '秋季', '通识课一', '通识课一', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中美关系史');
UPDATE courses SET tongshi = '通识课一', is_core = 0 WHERE name_cn = '中美关系史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张静' FROM courses WHERE name_cn = '中美关系史' HAVING MIN(id) IS NOT NULL;

-- 古代西亚北非神话与艺术 · 通识课三 · 核心课 · 04334010 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '古代西亚北非神话与艺术', '贾妍', 2, '秋季', '通识课三', '通识课三', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '古代西亚北非神话与艺术');
UPDATE courses SET tongshi = '通识课三', is_core = 1 WHERE name_cn = '古代西亚北非神话与艺术' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '贾妍' FROM courses WHERE name_cn = '古代西亚北非神话与艺术' HAVING MIN(id) IS NOT NULL;

-- 西方政治思想（现代） · 通识课一 · 核心课 · 02332213 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '西方政治思想（现代）', '吴增定', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '西方政治思想（现代）');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '西方政治思想（现代）' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴增定' FROM courses WHERE name_cn = '西方政治思想（现代）' HAVING MIN(id) IS NOT NULL;

-- 《理想国》 · 通识课一 · 核心课 · 02332976 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '《理想国》', '吴飞', 3, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '《理想国》');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '《理想国》' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴飞' FROM courses WHERE name_cn = '《理想国》' HAVING MIN(id) IS NOT NULL;

-- 户外探索 · 通识课三 · 04130621 体育教研部
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '户外探索', '钱俊伟', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '户外探索');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '户外探索' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '钱俊伟' FROM courses WHERE name_cn = '户外探索' HAVING MIN(id) IS NOT NULL;

-- 颗粒艺术 · 通识课三 · 04330335 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '颗粒艺术', '王楠', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '颗粒艺术');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '颗粒艺术' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王楠' FROM courses WHERE name_cn = '颗粒艺术' HAVING MIN(id) IS NOT NULL;

-- 鲁迅小说与世界文学 · 通识课一 · 核心课 · 02034330 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '鲁迅小说与世界文学', '张丽华', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '鲁迅小说与世界文学');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '鲁迅小说与世界文学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张丽华' FROM courses WHERE name_cn = '鲁迅小说与世界文学' HAVING MIN(id) IS NOT NULL;

-- 美术考古 · 通识课一 · 核心课 · 02232200 考古文博学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '美术考古', '倪润安', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '美术考古');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '美术考古' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '倪润安' FROM courses WHERE name_cn = '美术考古' HAVING MIN(id) IS NOT NULL;

-- 气候变化：全球变暖的科学基础 · 通识课四 · 核心课 · 00432300 物理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '气候变化：全球变暖的科学基础', 'Zhang Zhongshi（张仲石）', 2, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '气候变化：全球变暖的科学基础');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '气候变化：全球变暖的科学基础' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), 'Zhang Zhongshi（张仲石）' FROM courses WHERE name_cn = '气候变化：全球变暖的科学基础' HAVING MIN(id) IS NOT NULL;

-- 舌尖上的植物学 · 通识课四 · 21130003 现代农学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '舌尖上的植物学', '邓兴旺、李磊', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '舌尖上的植物学');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '舌尖上的植物学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '邓兴旺、李磊' FROM courses WHERE name_cn = '舌尖上的植物学' HAVING MIN(id) IS NOT NULL;

-- 世界电影史 · 通识课三 · 01831760 新闻与传播学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '世界电影史', '陆绍阳', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '世界电影史');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '世界电影史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陆绍阳' FROM courses WHERE name_cn = '世界电影史' HAVING MIN(id) IS NOT NULL;

-- 智识与审美 · 通识课三 · 02330873 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '智识与审美', '程乐松、江大勇、刘晨、李成晴等', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '智识与审美');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '智识与审美' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '程乐松、江大勇、刘晨、李成晴等' FROM courses WHERE name_cn = '智识与审美' HAVING MIN(id) IS NOT NULL;

-- 中苏关系及其对中国社会发展的影响 · 通识课二 · 02431930 国际关系学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中苏关系及其对中国社会发展的影响', '戴惟静', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中苏关系及其对中国社会发展的影响');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '中苏关系及其对中国社会发展的影响' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '戴惟静' FROM courses WHERE name_cn = '中苏关系及其对中国社会发展的影响' HAVING MIN(id) IS NOT NULL;

-- 国际法与国际关系 · 通识课二 · 核心课 · 02432440 国际关系学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '国际法与国际关系', '赖华夏', 3, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '国际法与国际关系');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '国际法与国际关系' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '赖华夏' FROM courses WHERE name_cn = '国际法与国际关系' HAVING MIN(id) IS NOT NULL;

-- 科技与政治 · 通识课二 · 03233570 政府管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '科技与政治', '顾超', 3, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '科技与政治');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '科技与政治' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '顾超' FROM courses WHERE name_cn = '科技与政治' HAVING MIN(id) IS NOT NULL;

-- 可再生能源与低碳社会 · 通识课四 · 00431740 物理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '可再生能源与低碳社会', '肖立新', 2, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '可再生能源与低碳社会');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '可再生能源与低碳社会' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '肖立新' FROM courses WHERE name_cn = '可再生能源与低碳社会' HAVING MIN(id) IS NOT NULL;

-- 素描：摹习与创作 · 通识课三 · 04331306 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '素描：摹习与创作', '徐紫迪', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '素描：摹习与创作');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '素描：摹习与创作' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '徐紫迪' FROM courses WHERE name_cn = '素描：摹习与创作' HAVING MIN(id) IS NOT NULL;

-- 小说鉴赏与写作 · 通识课三 · 02035650 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '小说鉴赏与写作', '樊迎春', 3, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '小说鉴赏与写作');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '小说鉴赏与写作' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '樊迎春' FROM courses WHERE name_cn = '小说鉴赏与写作' HAVING MIN(id) IS NOT NULL;

-- 英语新闻阅读 · 通识课二 · 01832760 新闻与传播学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '英语新闻阅读', '何姝', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '英语新闻阅读');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '英语新闻阅读' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '何姝' FROM courses WHERE name_cn = '英语新闻阅读' HAVING MIN(id) IS NOT NULL;

-- 中国近代史 · 通识课一 · 核心课 · 02130020 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中国近代史', '韩策', 4, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国近代史');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '中国近代史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '韩策' FROM courses WHERE name_cn = '中国近代史' HAVING MIN(id) IS NOT NULL;

-- 《史记》解读 · 通识课一 · 核心课 · 02132864 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '《史记》解读', '李霖', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '《史记》解读');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '《史记》解读' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李霖' FROM courses WHERE name_cn = '《史记》解读' HAVING MIN(id) IS NOT NULL;

-- 《资本论》选读 · 通识课二 · 核心课 · 02535370 经济学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '《资本论》选读', '刘充', 3, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '《资本论》选读');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '《资本论》选读' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘充' FROM courses WHERE name_cn = '《资本论》选读' HAVING MIN(id) IS NOT NULL;

-- 德语名家中国著述选读 · 通识课一 · 核心课 · 03632630 外国语学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '德语名家中国著述选读', '罗炜', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '德语名家中国著述选读');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '德语名家中国著述选读' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '罗炜' FROM courses WHERE name_cn = '德语名家中国著述选读' HAVING MIN(id) IS NOT NULL;

-- 经典昆曲欣赏 · 通识课三 · 04330111 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '经典昆曲欣赏', '陈均', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '经典昆曲欣赏');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '经典昆曲欣赏' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陈均' FROM courses WHERE name_cn = '经典昆曲欣赏' HAVING MIN(id) IS NOT NULL;

-- 民事司法与纠纷解决 · 通识课二 · 02930228 法学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '民事司法与纠纷解决', '曹志勋', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '民事司法与纠纷解决');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '民事司法与纠纷解决' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '曹志勋' FROM courses WHERE name_cn = '民事司法与纠纷解决' HAVING MIN(id) IS NOT NULL;

-- 孙子兵法导读 · 通识课一 · 60730330 学生工作部人民武装部
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '孙子兵法导读', '李敏、户国栋、王欣涛、张烨等', 2, '秋季', '通识课一', '通识课一', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '孙子兵法导读');
UPDATE courses SET tongshi = '通识课一', is_core = 0 WHERE name_cn = '孙子兵法导读' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李敏、户国栋、王欣涛、张烨等' FROM courses WHERE name_cn = '孙子兵法导读' HAVING MIN(id) IS NOT NULL;

-- 西方美术史 · 通识课三 · 核心课 · 04332710 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '西方美术史', '丁宁', 2, '秋季', '通识课三', '通识课三', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '西方美术史');
UPDATE courses SET tongshi = '通识课三', is_core = 1 WHERE name_cn = '西方美术史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '丁宁' FROM courses WHERE name_cn = '西方美术史' HAVING MIN(id) IS NOT NULL;

-- 现当代建筑 · 通识课三 · 核心课 · 12635320 城市与环境学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '现当代建筑', '董豫赣', 2, '秋季', '通识课三', '通识课三', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '现当代建筑');
UPDATE courses SET tongshi = '通识课三', is_core = 1 WHERE name_cn = '现当代建筑' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '董豫赣' FROM courses WHERE name_cn = '现当代建筑' HAVING MIN(id) IS NOT NULL;

-- 学术写作与表达 · 通识课二 · 核心课 · 02035100 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '学术写作与表达', '孙华、苏彦捷、张久珍、陈江等', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '学术写作与表达');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '学术写作与表达' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '孙华、苏彦捷、张久珍、陈江等' FROM courses WHERE name_cn = '学术写作与表达' HAVING MIN(id) IS NOT NULL;

-- 一国两制与基本法 · 通识课二 · 02930209 法学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '一国两制与基本法', '陈端洪', 3, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '一国两制与基本法');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '一国两制与基本法' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陈端洪' FROM courses WHERE name_cn = '一国两制与基本法' HAVING MIN(id) IS NOT NULL;

-- 中国现代社会史 · 通识课二 · 02138850 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '中国现代社会史', '王元周', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国现代社会史');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '中国现代社会史' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王元周' FROM courses WHERE name_cn = '中国现代社会史' HAVING MIN(id) IS NOT NULL;

-- 生物标本制作与艺术 · 通识课四 · 01131560 生命科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '生物标本制作与艺术', '龙玉、张泉、孟世勇、辛广伟等', 1, '秋季', '通识课四', '通识课四', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '生物标本制作与艺术');
UPDATE courses SET tongshi = '通识课四', is_core = 0 WHERE name_cn = '生物标本制作与艺术' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '龙玉、张泉、孟世勇、辛广伟等' FROM courses WHERE name_cn = '生物标本制作与艺术' HAVING MIN(id) IS NOT NULL;

-- 奥林匹克文化 · 通识课三 · 04130300 体育教研部
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '奥林匹克文化', '侯逸凡', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '奥林匹克文化');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '奥林匹克文化' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '侯逸凡' FROM courses WHERE name_cn = '奥林匹克文化' HAVING MIN(id) IS NOT NULL;

-- 环境伦理学 · 通识课二 · 02334020 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '环境伦理学', '苏贤贵', 2, '秋季', '通识课二', '通识课二', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '环境伦理学');
UPDATE courses SET tongshi = '通识课二', is_core = 0 WHERE name_cn = '环境伦理学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '苏贤贵' FROM courses WHERE name_cn = '环境伦理学' HAVING MIN(id) IS NOT NULL;

-- 环境与发展 · 通识课二 · 核心课 · 12733050 环境科学与工程学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '环境与发展', '王奇', 2, '秋季', '通识课二', '通识课二', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '环境与发展');
UPDATE courses SET tongshi = '通识课二', is_core = 1 WHERE name_cn = '环境与发展' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王奇' FROM courses WHERE name_cn = '环境与发展' HAVING MIN(id) IS NOT NULL;

-- 科学健身方法与实践 · 通识课三 · 04130741 体育教研部
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '科学健身方法与实践', '赫忠慧', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '科学健身方法与实践');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '科学健身方法与实践' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '赫忠慧' FROM courses WHERE name_cn = '科学健身方法与实践' HAVING MIN(id) IS NOT NULL;

-- 艺术经典里的百年中国 · 通识课三 · 04331921 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '艺术经典里的百年中国', '彭锋、陈均、顾春芳、刘晨等', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '艺术经典里的百年中国');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '艺术经典里的百年中国' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '彭锋、陈均、顾春芳、刘晨等' FROM courses WHERE name_cn = '艺术经典里的百年中国' HAVING MIN(id) IS NOT NULL;

-- 发展心理学 · 通识课四 · 核心课 · 01630060 心理与认知科学学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '发展心理学', '易莉', 3, '秋季', '通识课四', '通识课四', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '发展心理学');
UPDATE courses SET tongshi = '通识课四', is_core = 1 WHERE name_cn = '发展心理学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '易莉' FROM courses WHERE name_cn = '发展心理学' HAVING MIN(id) IS NOT NULL;

-- 古琴经典艺术欣赏 · 通识课三 · 04334019 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '古琴经典艺术欣赏', '陈均', 2, '秋季', '通识课三', '通识课三', 0
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '古琴经典艺术欣赏');
UPDATE courses SET tongshi = '通识课三', is_core = 0 WHERE name_cn = '古琴经典艺术欣赏' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陈均' FROM courses WHERE name_cn = '古琴经典艺术欣赏' HAVING MIN(id) IS NOT NULL;

-- 政治哲学 · 通识课一 · 核心课 · 02333371 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category, tongshi, is_core)
SELECT '政治哲学', '陈斯一', 2, '秋季', '通识课一', '通识课一', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '政治哲学');
UPDATE courses SET tongshi = '通识课一', is_core = 1 WHERE name_cn = '政治哲学' AND tongshi IS NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '陈斯一' FROM courses WHERE name_cn = '政治哲学' HAVING MIN(id) IS NOT NULL;
