-- One card per course, several teachers per course, and each review records
-- which teacher it is about.
--
--   course_teachers  one row per teacher option of a course. Co-teachers of
--                    one class are ONE option, e.g. "孟庆楠、白辉洪".
--   reviews.teacher  the option the reviewer chose.
--
-- Courses that were added once per teacher (same name, different teacher —
-- e.g. 中文工具书 ×3) are merged into the oldest of them; their teachers and
-- reviews move over.

CREATE TABLE IF NOT EXISTS course_teachers (
  id        INTEGER PRIMARY KEY AUTOINCREMENT,
  course_id INTEGER NOT NULL REFERENCES courses(id),
  teacher   TEXT NOT NULL,
  UNIQUE (course_id, teacher)
);

ALTER TABLE reviews ADD COLUMN teacher TEXT;

-- 1. Every course's current teacher becomes its first teacher option.
INSERT OR IGNORE INTO course_teachers (course_id, teacher)
SELECT id, TRIM(teacher) FROM courses
WHERE teacher IS NOT NULL AND TRIM(teacher) <> ''
ORDER BY id;

-- 2. Existing reviews were written for that teacher.
UPDATE reviews
SET teacher = (SELECT TRIM(c.teacher) FROM courses c WHERE c.id = reviews.course_id)
WHERE teacher IS NULL;

-- 3. Merge courses that share a name into the oldest one.
CREATE TABLE _course_merge AS
SELECT c.id AS dup_id,
       (SELECT MIN(c2.id) FROM courses c2 WHERE c2.name_cn = c.name_cn) AS keep_id
FROM courses c
WHERE c.id <> (SELECT MIN(c2.id) FROM courses c2 WHERE c2.name_cn = c.name_cn);

INSERT OR IGNORE INTO course_teachers (course_id, teacher)
SELECT m.keep_id, ct.teacher
FROM course_teachers ct JOIN _course_merge m ON m.dup_id = ct.course_id
ORDER BY ct.id;

-- Reviews move to the kept course. (A student who reviewed two of the merged
-- courses keeps only the first review — one review per person per course.)
UPDATE OR IGNORE reviews
SET course_id = (SELECT keep_id FROM _course_merge WHERE dup_id = reviews.course_id)
WHERE course_id IN (SELECT dup_id FROM _course_merge);
DELETE FROM reviews WHERE course_id IN (SELECT dup_id FROM _course_merge);

DELETE FROM course_teachers WHERE course_id IN (SELECT dup_id FROM _course_merge);
DELETE FROM courses WHERE id IN (SELECT dup_id FROM _course_merge);
DROP TABLE _course_merge;

CREATE INDEX IF NOT EXISTS idx_course_teachers_course ON course_teachers (course_id);
