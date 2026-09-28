-- Full schema of the course review database.
--
-- Every statement uses IF NOT EXISTS, so this file is safe to apply to BOTH
--   * a brand-new empty database (local development), and
--   * a database filled from an export of the live site, which already has
--     these tables — then it simply does nothing.
--
-- Future schema changes go in new files: 0002_<what>.sql, 0003_<what>.sql …
-- and are applied with `npm run db:migrate` (remote) / `npm run db:migrate:local`.

CREATE TABLE IF NOT EXISTS users (
  id            TEXT PRIMARY KEY,          -- random UUID
  email         TEXT NOT NULL UNIQUE,      -- school email, lower-case
  name          TEXT,
  role          TEXT DEFAULT 'undergrad',  -- undergrad | prep | grad
  avatar_url    TEXT,
  created_at    INTEGER,                   -- unix seconds
  last_login_at INTEGER
);

CREATE TABLE IF NOT EXISTS courses (
  id       INTEGER PRIMARY KEY AUTOINCREMENT,
  name_cn  TEXT NOT NULL,
  name_en  TEXT,
  teacher  TEXT,
  credits  REAL,
  semester TEXT,                           -- 秋季 | 春季 | 秋季/春季
  category TEXT
);

CREATE TABLE IF NOT EXISTS reviews (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  course_id      INTEGER NOT NULL REFERENCES courses(id),
  author_id      TEXT NOT NULL REFERENCES users(id),
  content_score  REAL,                     -- 0–10, higher = better content
  workload_score REAL,                     -- 0–10, higher = MORE homework
  grading_score  REAL,                     -- 0–10, higher = more generous
  midterm        TEXT,
  final          TEXT,
  homework       TEXT,
  attendance     TEXT,
  groupwork      TEXT,
  bigassignment  TEXT,
  grading_ratio  TEXT,
  comment        TEXT,
  is_anonymous   INTEGER NOT NULL DEFAULT 0,
  taken_semester TEXT,                     -- e.g. "2025 秋季"
  created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME
);

-- One review per person per course.
CREATE UNIQUE INDEX IF NOT EXISTS idx_reviews_author_course ON reviews (author_id, course_id);
CREATE INDEX IF NOT EXISTS idx_reviews_course ON reviews (course_id);

CREATE TABLE IF NOT EXISTS verification_codes (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  email      TEXT NOT NULL,
  code_hash  TEXT NOT NULL,                -- sha256(email + code + JWT_SECRET)
  expires_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL,
  consumed   INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_codes_email ON verification_codes (email, created_at);
