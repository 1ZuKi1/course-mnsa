-- Course categories are now a fixed list:
--   与中国有关课程 · 通识课一 · 通识课二 · 通识课三 · 通识课四 · 体育课
-- Every course that existed before this change came from the 政替 survey,
-- so the old placeholder labels (本科, empty) become 与中国有关课程.
-- Individual courses can be moved later with an UPDATE ... WHERE id = ?.
UPDATE courses
SET category = '与中国有关课程'
WHERE category IS NULL OR TRIM(category) IN ('', '本科');
