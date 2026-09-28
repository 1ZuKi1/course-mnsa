-- 2026 秋季 体育课 — imported from the university course list (体育课.docx).
--
-- * 44 courses, category 体育课, 1 学分, semester 秋季.
-- * One card per course; every teacher who teaches a section is a teacher
--   option (e.g. 太极拳 has 11), so reviews say which teacher's class it was.
-- * Skipped — no teacher listed, and mostly closed to ordinary students
--   (athletes / one major only, or placeholder courses):
--   保健5、高级体育训练（八）、高级体育训练（二）、高级体育训练（九）、高级体育训练（六）、高级体育训练（七）、高级体育训练（三）、高级体育训练（四）、高级体育训练（五）、高级体育训练（一）、竞赛训练（二）、竞赛训练（一）、体育二、体育三、体育四、体育一、运动训练（三）、运动训练（一）.
-- * Safe to run more than once.


-- 乒乓球 · 04130050
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '乒乓球', '周正卿', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '乒乓球');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '周正卿' FROM courses WHERE name_cn = '乒乓球' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴飞' FROM courses WHERE name_cn = '乒乓球' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘伟' FROM courses WHERE name_cn = '乒乓球' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '闵东旭' FROM courses WHERE name_cn = '乒乓球' HAVING MIN(id) IS NOT NULL;

-- 普拉提 · 04130047
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '普拉提', '伍迪', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '普拉提');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '伍迪' FROM courses WHERE name_cn = '普拉提' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '彭勃' FROM courses WHERE name_cn = '普拉提' HAVING MIN(id) IS NOT NULL;

-- 柔道 · 04130760
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '柔道', '曾庆东', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '柔道');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '曾庆东' FROM courses WHERE name_cn = '柔道' HAVING MIN(id) IS NOT NULL;

-- 体适能 · 04130160
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '体适能', '李晓彬', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '体适能');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李晓彬' FROM courses WHERE name_cn = '体适能' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '彭勃' FROM courses WHERE name_cn = '体适能' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '赫忠慧' FROM courses WHERE name_cn = '体适能' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '郭思佳' FROM courses WHERE name_cn = '体适能' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '谢智宇' FROM courses WHERE name_cn = '体适能' HAVING MIN(id) IS NOT NULL;

-- 网球 · 04130070
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '网球', '卢福泉', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '网球');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '卢福泉' FROM courses WHERE name_cn = '网球' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴昊' FROM courses WHERE name_cn = '网球' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李玉新' FROM courses WHERE name_cn = '网球' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘茂辉' FROM courses WHERE name_cn = '网球' HAVING MIN(id) IS NOT NULL;

-- 游泳 · 04130020
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '游泳', '李未名', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '游泳');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李未名' FROM courses WHERE name_cn = '游泳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘思宇' FROM courses WHERE name_cn = '游泳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '余潜' FROM courses WHERE name_cn = '游泳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李晓彬' FROM courses WHERE name_cn = '游泳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '萧文革' FROM courses WHERE name_cn = '游泳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张展嘉' FROM courses WHERE name_cn = '游泳' HAVING MIN(id) IS NOT NULL;

-- 瑜伽 · 04130440
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '瑜伽', '亓昕', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '瑜伽');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '亓昕' FROM courses WHERE name_cn = '瑜伽' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '彭勃' FROM courses WHERE name_cn = '瑜伽' HAVING MIN(id) IS NOT NULL;

-- 地板球 · 04130450
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '地板球', '周正卿', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '地板球');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '周正卿' FROM courses WHERE name_cn = '地板球' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '郑重' FROM courses WHERE name_cn = '地板球' HAVING MIN(id) IS NOT NULL;

-- 健美操 · 04130040
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '健美操', '万平', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '健美操');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '万平' FROM courses WHERE name_cn = '健美操' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '秦朗' FROM courses WHERE name_cn = '健美操' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王东宇' FROM courses WHERE name_cn = '健美操' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '伍迪' FROM courses WHERE name_cn = '健美操' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '袁睿超' FROM courses WHERE name_cn = '健美操' HAVING MIN(id) IS NOT NULL;

-- 篮球竞赛与裁判基础 · 04130096
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '篮球竞赛与裁判基础', '张亚谦', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '篮球竞赛与裁判基础');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张亚谦' FROM courses WHERE name_cn = '篮球竞赛与裁判基础' HAVING MIN(id) IS NOT NULL;

-- 艺术体操 · 04130042
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '艺术体操', '伍迪', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '艺术体操');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '伍迪' FROM courses WHERE name_cn = '艺术体操' HAVING MIN(id) IS NOT NULL;

-- 定向与徒步运动 · 04130620
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '定向与徒步运动', '潘昊然', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '定向与徒步运动');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '潘昊然' FROM courses WHERE name_cn = '定向与徒步运动' HAVING MIN(id) IS NOT NULL;

-- 飞盘运动 · 04130715
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '飞盘运动', '钱永健', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '飞盘运动');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '钱永健' FROM courses WHERE name_cn = '飞盘运动' HAVING MIN(id) IS NOT NULL;

-- 汉字太极与养生课 · 04130630
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '汉字太极与养生课', '李朝斌', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '汉字太极与养生课');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李朝斌' FROM courses WHERE name_cn = '汉字太极与养生课' HAVING MIN(id) IS NOT NULL;

-- 太极拳 · 04130030
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '太极拳', '王东敏', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '太极拳');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '王东敏' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '柴云龙' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '彭芳' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '孙洪霞' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴定锋' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '玄雨晴' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '汪琳' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李未名' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '冯凯杰' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴昊' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '罗子媛' FROM courses WHERE name_cn = '太极拳' HAVING MIN(id) IS NOT NULL;

-- 游泳提高班 · 04130021
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '游泳提高班', '余潜', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '游泳提高班');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '余潜' FROM courses WHERE name_cn = '游泳提高班' HAVING MIN(id) IS NOT NULL;

-- 排球提高班 · 04130103
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '排球提高班', '梁辰', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '排球提高班');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '梁辰' FROM courses WHERE name_cn = '排球提高班' HAVING MIN(id) IS NOT NULL;

-- 体育舞蹈 · 04130120
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '体育舞蹈', '吴定锋', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '体育舞蹈');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '吴定锋' FROM courses WHERE name_cn = '体育舞蹈' HAVING MIN(id) IS NOT NULL;

-- 壁球 · 04130660
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '壁球', '郑重', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '壁球');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '郑重' FROM courses WHERE name_cn = '壁球' HAVING MIN(id) IS NOT NULL;

-- 排球 · 04130100
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '排球', '梁辰', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '排球');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '梁辰' FROM courses WHERE name_cn = '排球' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘聪聪' FROM courses WHERE name_cn = '排球' HAVING MIN(id) IS NOT NULL;

-- 健美操有氧舞蹈 · 04130045
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '健美操有氧舞蹈', '车磊', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '健美操有氧舞蹈');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '车磊' FROM courses WHERE name_cn = '健美操有氧舞蹈' HAVING MIN(id) IS NOT NULL;

-- 攀岩 · 04130240
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '攀岩', '潘昊然', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '攀岩');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '潘昊然' FROM courses WHERE name_cn = '攀岩' HAVING MIN(id) IS NOT NULL;

-- 骑行教育 · 04130720
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '骑行教育', '卢福泉', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '骑行教育');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '卢福泉' FROM courses WHERE name_cn = '骑行教育' HAVING MIN(id) IS NOT NULL;

-- 射箭 · 04130710
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '射箭', '张冰', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '射箭');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张冰' FROM courses WHERE name_cn = '射箭' HAVING MIN(id) IS NOT NULL;

-- 体美 · 04130126
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '体美', '秦朗', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '体美');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '秦朗' FROM courses WHERE name_cn = '体美' HAVING MIN(id) IS NOT NULL;

-- 拓展训练 · 04130640
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '拓展训练', '钱永健', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '拓展训练');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '钱永健' FROM courses WHERE name_cn = '拓展训练' HAVING MIN(id) IS NOT NULL;

-- 中华毽 · 04130430
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '中华毽', '唐彦', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '中华毽');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '唐彦' FROM courses WHERE name_cn = '中华毽' HAVING MIN(id) IS NOT NULL;

-- 非遗太极拳（王其和式） · 04130032
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '非遗太极拳（王其和式）', '杜军明', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '非遗太极拳（王其和式）');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '杜军明' FROM courses WHERE name_cn = '非遗太极拳（王其和式）' HAVING MIN(id) IS NOT NULL;

-- 国际象棋 · 04130550
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '国际象棋', '侯逸凡', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '国际象棋');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '侯逸凡' FROM courses WHERE name_cn = '国际象棋' HAVING MIN(id) IS NOT NULL;

-- 匹克球 · 04130075
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '匹克球', '刘茂辉', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '匹克球');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘茂辉' FROM courses WHERE name_cn = '匹克球' HAVING MIN(id) IS NOT NULL;
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '李未名' FROM courses WHERE name_cn = '匹克球' HAVING MIN(id) IS NOT NULL;

-- 健身健美 · 04130136
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '健身健美', '张冰', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '健身健美');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张冰' FROM courses WHERE name_cn = '健身健美' HAVING MIN(id) IS NOT NULL;

-- 篮球提高班 · 04130093
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '篮球提高班', '马振宇', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '篮球提高班');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '马振宇' FROM courses WHERE name_cn = '篮球提高班' HAVING MIN(id) IS NOT NULL;

-- 羽毛球提高班 · 04130063
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '羽毛球提高班', '欧阳泽蔓', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '羽毛球提高班');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '欧阳泽蔓' FROM courses WHERE name_cn = '羽毛球提高班' HAVING MIN(id) IS NOT NULL;

-- 高尔夫 · 04130480
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '高尔夫', '何仲恺', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '高尔夫');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '何仲恺' FROM courses WHERE name_cn = '高尔夫' HAVING MIN(id) IS NOT NULL;

-- 击剑 · 04130290
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '击剑', '孙玉洁', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '击剑');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '孙玉洁' FROM courses WHERE name_cn = '击剑' HAVING MIN(id) IS NOT NULL;

-- 跆拳道 · 04130280
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '跆拳道', '刘林青', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '跆拳道');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘林青' FROM courses WHERE name_cn = '跆拳道' HAVING MIN(id) IS NOT NULL;

-- 棒、垒球 · 04130210
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '棒、垒球', '黄春棉', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '棒、垒球');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '黄春棉' FROM courses WHERE name_cn = '棒、垒球' HAVING MIN(id) IS NOT NULL;

-- 气排球 · 04130105
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '气排球', '梁辰', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '气排球');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '梁辰' FROM courses WHERE name_cn = '气排球' HAVING MIN(id) IS NOT NULL;

-- 无极球 · 04130750
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '无极球', '刘林青', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '无极球');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘林青' FROM courses WHERE name_cn = '无极球' HAVING MIN(id) IS NOT NULL;

-- 保健4 · 04130173
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '保健4', '侯筱', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '保健4');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '侯筱' FROM courses WHERE name_cn = '保健4' HAVING MIN(id) IS NOT NULL;

-- 导引与养生 · 04130730
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '导引与养生', '杜军明', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '导引与养生');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '杜军明' FROM courses WHERE name_cn = '导引与养生' HAVING MIN(id) IS NOT NULL;

-- 体能提升：运动与膳食 · 04130355
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '体能提升：运动与膳食', '张晓圆', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '体能提升：运动与膳食');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '张晓圆' FROM courses WHERE name_cn = '体能提升：运动与膳食' HAVING MIN(id) IS NOT NULL;

-- 舞龙舞狮（初级班） · 04130034
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '舞龙舞狮（初级班）', '冯凯杰', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '舞龙舞狮（初级班）');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '冯凯杰' FROM courses WHERE name_cn = '舞龙舞狮（初级班）' HAVING MIN(id) IS NOT NULL;

-- 散打 · 04130420
INSERT INTO courses (name_cn, teacher, credits, semester, category)
SELECT '散打', '刘林青', 1, '秋季', '体育课'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE name_cn = '散打');
INSERT OR IGNORE INTO course_teachers (course_id, teacher) SELECT MIN(id), '刘林青' FROM courses WHERE name_cn = '散打' HAVING MIN(id) IS NOT NULL;
