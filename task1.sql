DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS resumes;
DROP TABLE IF EXISTS vacancies;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS areas;
DROP TABLE IF EXISTS specializations;


-- Таблицы содержат минимально необходимые поля для выполнения дз с небольшими дополнениями
-- Не уверен в совпадении типов первичных ключей с таблицами оригинальной базы, но надеюсь в
-- рамках дз это не сильно критично


CREATE TABLE users (
  id UUID PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE companies (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE areas (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE specializations (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE resumes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  user_id UUID NOT NULL REFERENCES users(id),
  area_id INTEGER NOT NULL REFERENCES areas(id),
  specialization_id INTEGER NOT NULL REFERENCES specializations(id),
  compensation_from INTEGER,
  compensation_to INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
  CONSTRAINT at_least_one_compensation_present
    CHECK (compensation_from IS NOT NULL OR compensation_to IS NOT NULL)
);


CREATE TABLE vacancies (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  company_id INTEGER NOT NULL REFERENCES companies(id),
  area_id INTEGER NOT NULL REFERENCES areas(id),
  specialization_id INTEGER NOT NULL REFERENCES specializations(id),
  compensation_from INTEGER,
  compensation_to INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- В последний момент понял, что вакансия может быть в целом без указания зп, в таком случае нужно
  -- убрать ограничение и не учитывать такие вакансии при подсчете статистики
  CONSTRAINT at_least_one_compensation_present
    CHECK (compensation_from IS NOT NULL OR compensation_to IS NOT NULL)
);

CREATE TABLE applications (
  resume_id SERIAL REFERENCES resumes(id) ON DELETE CASCADE,
  vacancy_id SERIAL REFERENCES vacancies(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (resume_id, vacancy_id)
);