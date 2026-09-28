-- 2026 秋季 与中国有关课程 — imported from the university course list (与中国有关课程.docx).
--
-- * 60 new courses, all category 与中国有关课程, semester 秋季.
-- * Teachers are stored without titles; several teachers are joined with 、.
-- * 9 courses on the list were already on the site and are NOT added again:
--     中国政治概论, 马克思主义新闻观, 中国新闻史, 走近中国书法, 中国民俗与社会生活,
--     中华人民共和国对外关系, 中国近现代史重大问题研究, 中国现代社会史,
--     中国商业管理思想 (on the site with a typo — fixed below).
-- * 中国哲学（上） appeared twice (lecture 02330092 + section 02330094); added once.
-- * Safe to run more than once: each insert is skipped if the same name + teacher exists.

-- Fix the typo in an existing course name (official name: 中国商业管理思想).
UPDATE courses SET name_cn = '中国商业管理思想'
WHERE name_cn = '中国商业思想管理' AND teacher = '周建波';

-- Fill in the missing teacher of an existing course.
UPDATE courses SET teacher = '祝鹏程'
WHERE name_cn = '中国民俗与社会生活' AND (teacher IS NULL OR TRIM(teacher) = '');

INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国哲学（上）', '孟庆楠、白辉洪', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国哲学（上）' AND IFNULL(teacher, '') = '孟庆楠、白辉洪');  -- 02330092 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '《红楼梦》与中国文化艺术', '刘勇强、顾春芳', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '《红楼梦》与中国文化艺术' AND IFNULL(teacher, '') = '刘勇强、顾春芳');  -- 04332222 艺术学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代史（下）', '李新峰', 4, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代史（下）' AND IFNULL(teacher, '') = '李新峰');  -- 02130012 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国法律思想史', '张一民', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国法律思想史' AND IFNULL(teacher, '') = '张一民');  -- 02930020 法学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代文学史（四）', '刘勇强', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代文学史（四）' AND IFNULL(teacher, '') = '刘勇强');  -- 02030034 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国自然地理', '连旭', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国自然地理' AND IFNULL(teacher, '') = '连旭');  -- 01531130 城市与环境学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中共党史专题', '黄道炫', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中共党史专题' AND IFNULL(teacher, '') = '黄道炫');  -- 02132990 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国社会福利', '鄢盛明', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国社会福利' AND IFNULL(teacher, '') = '鄢盛明');  -- 03131390 社会学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国政治思想史', '罗祎楠', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国政治思想史' AND IFNULL(teacher, '') = '罗祎楠');  -- 03230780 政府管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国金融改革', '黄益平', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国金融改革' AND IFNULL(teacher, '') = '黄益平');  -- 06239155 国家发展研究院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '专业汉语（一）', '徐沁仪', 1, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '专业汉语（一）' AND IFNULL(teacher, '') = '徐沁仪');  -- 02431093 国际关系学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '当代中国考试招生制度改革', '秦春华', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '当代中国考试招生制度改革' AND IFNULL(teacher, '') = '秦春华');  -- 06734040 教育学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '投资中国', 'LUHAI、沈俏蔚', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '投资中国' AND IFNULL(teacher, '') = 'LUHAI、沈俏蔚');  -- E2800220 光华管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代文化', '杜以恒', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代文化' AND IFNULL(teacher, '') = '杜以恒');  -- 02031540 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国当代文学', '路杨', 4, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国当代文学' AND IFNULL(teacher, '') = '路杨');  -- 02033360 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国考古学（中二）', '杨哲峰', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国考古学（中二）' AND IFNULL(teacher, '') = '杨哲峰');  -- 02232104 考古文博学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '古文选读', '胡敕瑞', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '古文选读' AND IFNULL(teacher, '') = '胡敕瑞');  -- 02080440 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代文学（上）', '常森、钱志熙', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代文学（上）' AND IFNULL(teacher, '') = '常森、钱志熙');  -- 02035201 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代文学史（四）', '白一瑾', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代文学史（四）' AND IFNULL(teacher, '') = '白一瑾');  -- 02030034 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国经济史', '郝煜', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国经济史' AND IFNULL(teacher, '') = '郝煜');  -- 02535240 经济学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国现代文学（上）', '高远东', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国现代文学（上）' AND IFNULL(teacher, '') = '高远东');  -- 02080261 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国政府与政治', '张长东', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国政府与政治' AND IFNULL(teacher, '') = '张长东');  -- 03232960 政府管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国宗教史', '李四龙', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国宗教史' AND IFNULL(teacher, '') = '李四龙');  -- 02332250 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '孟子哲学', '白辉洪', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '孟子哲学' AND IFNULL(teacher, '') = '白辉洪');  -- 02335201 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国传统官僚政治制度', '叶炜', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国传统官僚政治制度' AND IFNULL(teacher, '') = '叶炜');  -- 02131310 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国国际法实践', '陈晓航', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国国际法实践' AND IFNULL(teacher, '') = '陈晓航');  -- 02930237 法学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国经济', '王辉、周黎安、唐遥', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国经济' AND IFNULL(teacher, '') = '王辉、周黎安、唐遥');  -- 02830150 光华管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国通史（古代部分）', '陈侃理', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国通史（古代部分）' AND IFNULL(teacher, '') = '陈侃理');  -- 02132750 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国政治制度史', '孙明', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国政治制度史' AND IFNULL(teacher, '') = '孙明');  -- 03230770 政府管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代史（上）', '朱玉麒', 4, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代史（上）' AND IFNULL(teacher, '') = '朱玉麒');  -- 02130011 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '专业文献选读（一）', '沈青兰', 1, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '专业文献选读（一）' AND IFNULL(teacher, '') = '沈青兰');  -- 02432421 国际关系学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国对外经济', '陶涛', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国对外经济' AND IFNULL(teacher, '') = '陶涛');  -- 02535380 经济学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代史B（上）', '付马', 4, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代史B（上）' AND IFNULL(teacher, '') = '付马');  -- 02180011 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国神话研究', '陈连山', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国神话研究' AND IFNULL(teacher, '') = '陈连山');  -- 02030350 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国当代法律和社会', '彭錞', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国当代法律和社会' AND IFNULL(teacher, '') = '彭錞');  -- 02930187 法学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中文工具书', '张学谦', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中文工具书' AND IFNULL(teacher, '') = '张学谦');  -- 02033090 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中文工具书', '李成晴', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中文工具书' AND IFNULL(teacher, '') = '李成晴');  -- 02033090 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国概况', '赵杨', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国概况' AND IFNULL(teacher, '') = '赵杨');  -- 04430003 对外汉语教育学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代文学（二）', '叶晔', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代文学（二）' AND IFNULL(teacher, '') = '叶晔');  -- 02080342 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代文学史（二）', '杜晓勤', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代文学史（二）' AND IFNULL(teacher, '') = '杜晓勤');  -- 02030032 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国文物建筑导论', '张剑葳、俞莉娜', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国文物建筑导论' AND IFNULL(teacher, '') = '张剑葳、俞莉娜');  -- 02231021 考古文博学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '《庄子》精读', '杨立华', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '《庄子》精读' AND IFNULL(teacher, '') = '杨立华');  -- 02333202 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '国际传播与中国形象——重读经典《红星照耀中国》', '龚文庠、范士明、孙华、张慧瑜等', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '国际传播与中国形象——重读经典《红星照耀中国》' AND IFNULL(teacher, '') = '龚文庠、范士明、孙华、张慧瑜等');  -- 02432471 国际关系学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代文学（四）', '陆胤', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代文学（四）' AND IFNULL(teacher, '') = '陆胤');  -- 02080344 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国经济专题', '李力行', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国经济专题' AND IFNULL(teacher, '') = '李力行');  -- 06234900 国家发展研究院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国考古学（下一）', '沈睿文', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国考古学（下一）' AND IFNULL(teacher, '') = '沈睿文');  -- 02232105 考古文博学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国历史文选（上）', '杨坤', 4, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国历史文选（上）' AND IFNULL(teacher, '') = '杨坤');  -- 02130101 历史学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '文物鉴赏', '杭侃', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '文物鉴赏' AND IFNULL(teacher, '') = '杭侃');  -- 02231280 考古文博学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '现代汉语（下）', '朱彦', 4, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '现代汉语（下）' AND IFNULL(teacher, '') = '朱彦');  -- 02080042 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中共党史', '赵诺', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中共党史' AND IFNULL(teacher, '') = '赵诺');  -- 04030701 马克思主义学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国美学史', '许家瑜', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国美学史' AND IFNULL(teacher, '') = '许家瑜');  -- 02330840 哲学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中苏关系及其对中国社会发展的影响', '戴惟静', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中苏关系及其对中国社会发展的影响' AND IFNULL(teacher, '') = '戴惟静');  -- 02431930 国际关系学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中文工具书', '李林芳', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中文工具书' AND IFNULL(teacher, '') = '李林芳');  -- 02033090 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '专书选读（三）', '郜同麟', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '专书选读（三）' AND IFNULL(teacher, '') = '郜同麟');  -- 02035313 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '古代汉语（上）', '向筱路', 4, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '古代汉语（上）' AND IFNULL(teacher, '') = '向筱路');  -- 02030021 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '理解中国：问题、方法与实践', '顾佳峰、姚佳慧、丁华、孙妍等', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '理解中国：问题、方法与实践' AND IFNULL(teacher, '') = '顾佳峰、姚佳慧、丁华、孙妍等');  -- 18730001 中国社会科学调查中心
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国古代文学史（二）', '钱志熙', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国古代文学史（二）' AND IFNULL(teacher, '') = '钱志熙');  -- 02030032 中国语言文学系
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '一国两制与基本法', '陈端洪', 3, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '一国两制与基本法' AND IFNULL(teacher, '') = '陈端洪');  -- 02930209 法学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中国营销', '赵璞', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中国营销' AND IFNULL(teacher, '') = '赵璞');  -- E2800170 光华管理学院
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '艺术经典里的百年中国', '彭锋、陈均、顾春芳、刘晨等', 2, '秋季', '与中国有关课程'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '艺术经典里的百年中国' AND IFNULL(teacher, '') = '彭锋、陈均、顾春芳、刘晨等');  -- 04331921 艺术学院
