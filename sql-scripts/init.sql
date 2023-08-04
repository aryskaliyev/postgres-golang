CREATE TABLE location (
  location_id SERIAL PRIMARY KEY,
  city VARCHAR(50) UNIQUE NOT NULL,
  region VARCHAR(50) UNIQUE NOT NULL,
  country VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE exam (
  exam_id SERIAL PRIMARY KEY,
  name  VARCHAR(100) UNIQUE NOT NULL,
  short_name VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE subject (
  subject_id SERIAL PRIMARY KEY,
  exam_id INT NOT NULL REFERENCES exam (exam_id),
  name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE module (
  module_id SERIAL PRIMARY KEY,
  subject_id INT NOT NULL REFERENCES subject (subject_id),
  name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE topic (
  topic_id SERIAL PRIMARY KEY,
  module_id INT NOT NULL REFERENCES module (module_id),
  name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TYPE user_status AS ENUM ('active', 'suspended', 'banned');

CREATE TABLE useraccount (
  user_id SERIAL PRIMARY KEY,
  location_id INT NOT NULL REFERENCES location (location_id),
  first_name VARCHAR(20) NOT NULL,
  last_name VARCHAR(20) NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  passhash VARCHAR(64) NOT NULL,
  status user_status NOT NULL DEFAULT 'active'
);

CREATE TYPE event_or_round_status AS ENUM ('active', 'past');

CREATE TABLE event (
  event_id SERIAL PRIMARY KEY,
  exam_id INT NOT NULL REFERENCES exam (exam_id),
  description TEXT NOT NULL,
  start_date DATE NOT NULL,
  start_time TIME NOT NULL,
  registration_deadline_date DATE NOT NULL,
  registration_deadline_time TIME NOT NULL,
  event_status event_or_round_status NOT NULL,
  price NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE user_event (
  user_event_id SERIAL PRIMARY KEY,
  event_id INT NOT NULL REFERENCES event (event_id),
  user_id INT NOT NULL REFERENCES useraccount (user_id),
  registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE round (
  round_id SERIAL PRIMARY KEY,
  event_id INT NOT NULL REFERENCES event (event_id),
  subject_id INT NOT NULL REFERENCES subject (subject_id),
  round_sn INT UNIQUE NOT NULL,
  length INTERVAL NOT NULL,
  round_status event_or_round_status NOT NULL
);

CREATE TABLE problem (
  problem_id SERIAL PRIMARY KEY,
  topic_id INT NOT NULL REFERENCES topic (topic_id),
  round_id INT NOT NULL REFERENCES round (round_id),
  problem_sequence_number INT NOT NULL,
  problem_hash VARCHAR(100) UNIQUE NOT NULL
);

CREATE TYPE option AS ENUM ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H');

CREATE TABLE user_round_problem (
  user_round_problem_id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES useraccount (user_id),
  round_id INT NOT NULL REFERENCES round (round_id),
  problem_id INT NOT NULL REFERENCES problem (problem_id),
  user_option option NOT NULL,
  correct_option option NOT NULL,
  is_correct BOOLEAN NOT NULL,
  score_earned SMALLINT NOT NULL CHECK (score_earned >= 0),
  xp_earned SMALLINT NOT NULL CHECK (xp_earned >= 0)
);

CREATE TABLE bookmark (
  bookmark_id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES useraccount (user_id),
  round_id INT NOT NULL REFERENCES round (round_id),
  problem_id INT NOT NULL REFERENCES problem (problem_id)
);

CREATE TABLE user_purchase (
  user_purchase_id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES useraccount (user_id),
  event_id INT NOT NULL REFERENCES event (event_id),
  purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE admin (
  admin_id SERIAL PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  passhash VARCHAR(64) NOT NULL
);