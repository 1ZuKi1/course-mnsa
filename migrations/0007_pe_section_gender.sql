-- 男生班 / 女生班 for 体育课 sections.
--
-- course_teachers.note holds what the university list says about that
-- teacher's sections: 男生班, 女生班, or 男生班 / 女生班 when the teacher has
-- both. Sections without a note are open to everyone (note stays NULL).
-- The site shows it on the course card, the teacher buttons and the review
-- form's teacher choice.

ALTER TABLE course_teachers ADD COLUMN note TEXT;

UPDATE course_teachers SET note = '女生班' WHERE teacher = '伍迪' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '普拉提');  -- 普拉提
UPDATE course_teachers SET note = '女生班' WHERE teacher = '彭勃' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '普拉提');  -- 普拉提
UPDATE course_teachers SET note = '男生班' WHERE teacher = '李未名' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '游泳');  -- 游泳
UPDATE course_teachers SET note = '男生班 / 女生班' WHERE teacher = '刘思宇' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '游泳');  -- 游泳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '李晓彬' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '游泳');  -- 游泳
UPDATE course_teachers SET note = '女生班' WHERE teacher = '萧文革' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '游泳');  -- 游泳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '张展嘉' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '游泳');  -- 游泳
UPDATE course_teachers SET note = '女生班' WHERE teacher = '万平' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '健美操');  -- 健美操
UPDATE course_teachers SET note = '女生班' WHERE teacher = '秦朗' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '健美操');  -- 健美操
UPDATE course_teachers SET note = '女生班' WHERE teacher = '王东宇' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '健美操');  -- 健美操
UPDATE course_teachers SET note = '女生班' WHERE teacher = '伍迪' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '健美操');  -- 健美操
UPDATE course_teachers SET note = '女生班' WHERE teacher = '袁睿超' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '健美操');  -- 健美操
UPDATE course_teachers SET note = '女生班' WHERE teacher = '伍迪' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '艺术体操');  -- 艺术体操
UPDATE course_teachers SET note = '男生班' WHERE teacher = '李朝斌' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '汉字太极与养生课');  -- 汉字太极与养生课
UPDATE course_teachers SET note = '男生班' WHERE teacher = '王东敏' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '柴云龙' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '彭芳' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '孙洪霞' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '玄雨晴' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '汪琳' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '李未名' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '冯凯杰' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班 / 女生班' WHERE teacher = '吴昊' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班' WHERE teacher = '罗子媛' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '太极拳');  -- 太极拳
UPDATE course_teachers SET note = '男生班 / 女生班' WHERE teacher = '吴定锋' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '体育舞蹈');  -- 体育舞蹈
UPDATE course_teachers SET note = '女生班' WHERE teacher = '车磊' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '健美操有氧舞蹈');  -- 健美操有氧舞蹈
UPDATE course_teachers SET note = '女生班' WHERE teacher = '秦朗' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '体美');  -- 体美
UPDATE course_teachers SET note = '男生班' WHERE teacher = '杜军明' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '非遗太极拳（王其和式）');  -- 非遗太极拳（王其和式）
UPDATE course_teachers SET note = '男生班' WHERE teacher = '马振宇' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '篮球提高班');  -- 篮球提高班
UPDATE course_teachers SET note = '男生班' WHERE teacher = '刘林青' AND course_id = (SELECT MIN(id) FROM courses WHERE name_cn = '无极球');  -- 无极球
