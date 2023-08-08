CREATE TABLE location (
  location_id SERIAL PRIMARY KEY,
  city VARCHAR(50) UNIQUE NOT NULL,
  region VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL
);

CREATE TABLE exam (
  exam_id SERIAL PRIMARY KEY,
  name  VARCHAR(100) UNIQUE NOT NULL,
  short_name VARCHAR(10) UNIQUE NOT NULL
);

CREATE TYPE user_status AS ENUM ('active', 'suspended', 'banned');

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
  round_sn INT NOT NULL,
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

-- INSERT INTO location (city, region, country) VALUES ('astana', 'astana city', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('almaty', 'almaty city', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('shymkent', 'shymkent city', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('kokshetau', 'akmola region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('aktobe', 'aktobe region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('atyrau', 'atyrau region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('aksai', 'west kazakhstan region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('oral', 'west kazakhstan region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('oskemen', 'east kazakhstan region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('taraz', 'zhambyl region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('karaganda', 'karaganda region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('temirtau', 'karaganda region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('kostanay', 'kostanay region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('kyzylorda', 'kyzylorda region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('aktau', 'mangystau region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('pavlodar', 'pavlodar region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('yekibastuz', 'pavlodar region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('petropavlovsk', 'north kazakhstan region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('turkestan', 'turkestan region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('semey', 'abay region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('taldykorgan', 'zhetysu region', 'kazakhstan');
-- INSERT INTO location (city, region, country) VALUES ('zhezkazgan', 'ulytau region', 'kazakhstan');

-- INSERT INTO exam (name, short_name) VALUES ('nazarbayev university entrance test', 'nuet');

-- INSERT INTO subject (exam_id, name) VALUES (1, 'mathematics');
-- INSERT INTO subject (exam_id, name) VALUES (1, 'critical thinking and problem solving');

-- INSERT INTO module (subject_id, name) VALUES (1, 'numbers');
-- INSERT INTO module (subject_id, name) VALUES (1, 'ratio and proportion');
-- INSERT INTO module (subject_id, name) VALUES (1, 'algebra');
-- INSERT INTO module (subject_id, name) VALUES (1, 'geometry');

-- INSERT INTO module (subject_id, name) VALUES (2, 'critical thinking');
-- INSERT INTO module (subject_id, name) VALUES (2, 'problem solving');

-- INSERT INTO topic (module_id, name) VALUES (1, 'binary operations');
-- INSERT INTO topic (module_id, name) VALUES (3, 'inequalities');
-- INSERT INTO topic (module_id, name) VALUES (3, 'simultaneous equations');
-- INSERT INTO topic (module_id, name) VALUES (3, 'mixed simple');
-- INSERT INTO topic (module_id, name) VALUES (3, 'evaluate formula or expression with given numerical values');
-- INSERT INTO topic (module_id, name) VALUES (3, 'evaluate expressions with numerical values');
-- INSERT INTO topic (module_id, name) VALUES (3, 're-arranging formulae or expression');
-- INSERT INTO topic (module_id, name) VALUES (3, 'quadratic equations');
-- INSERT INTO topic (module_id, name) VALUES (3, 'bearings');
-- INSERT INTO topic (module_id, name) VALUES (3, 'trigonometry');
-- INSERT INTO topic (module_id, name) VALUES (3, 'simultaneous linear equations');
-- INSERT INTO topic (module_id, name) VALUES (3, 'sets and venn diagrams');
-- INSERT INTO topic (module_id, name) VALUES (1, 'probability');
-- INSERT INTO topic (module_id, name) VALUES (1, 'listing strategies');
-- INSERT INTO topic (module_id, name) VALUES (3, 'simplifying algebraic expressions');
-- INSERT INTO topic (module_id, name) VALUES (3, 'functions and graphs');
-- INSERT INTO topic (module_id, name) VALUES (4, 'sectors, segments and arcs');
-- INSERT INTO topic (module_id, name) VALUES (3, 'equation of a straight line');
-- INSERT INTO topic (module_id, name) VALUES (3, 'choose from statements');
-- INSERT INTO topic (module_id, name) VALUES (4, 'surface area and volume');
-- INSERT INTO topic (module_id, name) VALUES (4, 'triangles');
-- INSERT INTO topic (module_id, name) VALUES (4, 'polygons');
-- INSERT INTO topic (module_id, name) VALUES (4, 'prisms, cubes and cuboids');
-- INSERT INTO topic (module_id, name) VALUES (3, 'sequences');
-- INSERT INTO topic (module_id, name) VALUES (3, 'progressions');
-- INSERT INTO topic (module_id, name) VALUES (4, 'cylinders, cones, pyramids and spheres');
-- INSERT INTO topic (module_id, name) VALUES (3, 'other equations');
-- INSERT INTO topic (module_id, name) VALUES (4, 'circles');
-- INSERT INTO topic (module_id, name) VALUES (4, 'composite shapes and composite solids');
-- INSERT INTO topic (module_id, name) VALUES (4, 'quadrilaterals');
-- INSERT INTO topic (module_id, name) VALUES (3, 'statistics');
-- INSERT INTO topic (module_id, name) VALUES (3, 'polynomial division');
-- INSERT INTO topic (module_id, name) VALUES (2, 'apply ratio to contexts and problems');
-- INSERT INTO topic (module_id, name) VALUES (2, 'percentage and percentage change');
-- INSERT INTO topic (module_id, name) VALUES (2, 'growth and decay');
-- INSERT INTO topic (module_id, name) VALUES (2, 'direct and inverse proportion');
-- INSERT INTO topic (module_id, name) VALUES (2, 'compare lengths, areas and volumes');
-- INSERT INTO topic (module_id, name) VALUES (2, 'miscellaneous');

-- INSERT INTO topic (module_id, name) VALUES (5, 'identifying the main conclusion');
-- INSERT INTO topic (module_id, name) VALUES (5, 'detecting reasoning errors');
-- INSERT INTO topic (module_id, name) VALUES (5, 'drawing a conclusion');
-- INSERT INTO topic (module_id, name) VALUES (5, 'identifying an assumption');
-- INSERT INTO topic (module_id, name) VALUES (5, 'assessing the impact of additional evidence');
-- INSERT INTO topic (module_id, name) VALUES (5, 'matching arguments');
-- INSERT INTO topic (module_id, name) VALUES (5, 'applying principles');

-- INSERT INTO topic (module_id, name) VALUES (6, 'problem solving category');

-- INSERT INTO useraccount (location_id, first_name, last_name, username, email, passhash) VALUES (1, 'hashirama', 'senju', 'hashirama.senju', 'hashirama.senju@gmail.com', 'firsthokage');
-- INSERT INTO useraccount (location_id, first_name, last_name, username, email, passhash) VALUES (2, 'tobirama', 'senju', 'tobirama.senju', 'tobirama.senju@gmail.com', 'secondhokage');
-- INSERT INTO useraccount (location_id, first_name, last_name, username, email, passhash) VALUES (3, 'hiruzen', 'sarutobi', 'hiruzen.sarutobi', 'hiruzen.sarutobi@gmail.com', 'thirdhokage');
-- INSERT INTO useraccount (location_id, first_name, last_name, username, email, passhash) VALUES (4, 'minato', 'namikaze', 'minato.namikaze', 'minato.namikaze@gmail.com', 'fourthhokage');
-- INSERT INTO useraccount (location_id, first_name, last_name, username, email, passhash) VALUES (5, 'tsunade', 'senju', 'tsunade.senju', 'tsunade.senju@gmail.com', 'fifthhokage');
-- INSERT INTO useraccount (location_id, first_name, last_name, username, email, passhash) VALUES (6, 'kakashi', 'hatake', 'kakashi.hatake', 'kakashi.hatake@gmail.com', 'sixthhokage');
-- INSERT INTO useraccount (location_id, first_name, last_name, username, email, passhash) VALUES (7, 'naruto', 'uzumaki', 'naruto.uzumaki', 'naruto.uzumaki@gmail.com', 'seventhhokage');

CREATE OR REPLACE FUNCTION insert_into_round_table()
RETURNS TRIGGER AS
$$
BEGIN
  INSERT INTO round (event_id, subject_id, round_sn, length, round_status)
  VALUES (NEW.event_id, 1, 1, INTERVAL '1 hour', 'active'),
         (NEW.event_id, 2, 2, INTERVAL '1 hour', 'active');
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insert_round_data
  AFTER INSERT ON event
  FOR EACH ROW
  EXECUTE FUNCTION insert_into_round_table();

-- INSERT INTO event (exam_id, description, start_date, start_time, registration_deadline_date, registration_deadline_time, event_status, price) VALUES (1, 'First event of Unofficial NUET Mock Exam', '2023-08-07', '12:30:00', '2023-08-07', '10:30:00', 'active', 1000.00);
