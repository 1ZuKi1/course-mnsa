-- Sample data for LOCAL development only (`npm run db:seed:local`).
-- Never run this against the real database.
INSERT OR IGNORE INTO users (id, email, name, role, created_at, last_login_at) VALUES
  ('dev-user-1', 'dev1@stu.pku.edu.cn', 'Туршилт Нэг', 'undergrad', 0, 0),
  ('dev-user-2', 'dev2@stu.pku.edu.cn', 'Туршилт Хоёр', 'undergrad', 0, 0);

INSERT OR IGNORE INTO courses (id, name_cn, teacher, credits, semester, category) VALUES
  (1, '中国历史文选B（上）', '王铿', 4, '秋季', '与中国有关课程'),
  (2, '中国电影史', '李道新', 2, '秋季', '与中国有关课程'),
  (3, '中国政治概论', '雷少华', 3, '秋季', '与中国有关课程'),
  (4, '现代汉语（上）', NULL, 3, '春季', '与中国有关课程'),
  (5, '中国对外经贸战略', NULL, 2, '秋季', '与中国有关课程'),
  (6, '（测试）通识课示例一', NULL, 2, '秋季', '通识课一'),
  (7, '（测试）通识课示例三', NULL, 2, '春季', '通识课三'),
  (8, '（测试）羽毛球', NULL, 1, '秋季', '体育课');

INSERT OR IGNORE INTO reviews (course_id, author_id, content_score, workload_score, grading_score, final, attendance, grading_ratio, comment, is_anonymous, taken_semester) VALUES
  (2, 'dev-user-1', 2, 3, 9, '开卷，可用电子产品', 'Хичээл бүр нэр дууддаг', '考勤+小组pre+开卷期末考试', 'Туршилтын сэтгэгдэл: дүнгээ сайн өгсөн, шалгалтад бэлдэх шаардлагагүй.', 0, '2024 秋季'),
  (2, 'dev-user-2', 6, 5, 9, NULL, NULL, NULL, 'Ер нь л авахад дажгүй санагдсан.', 1, NULL),
  (1, 'dev-user-2', 7, 4, 8, '闭卷', NULL, '平时20%+期中20%+期末60%', NULL, 0, '2025 春季');
