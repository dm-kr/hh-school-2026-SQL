INSERT INTO users (id, name)
SELECT
  gen_random_uuid(),
  'User ' || user_ids.id
FROM generate_series(1, 100000) user_ids(id);


INSERT INTO areas (name)
SELECT
  'Area ' || area_ids.id
FROM generate_series(1, 100) area_ids(id);


INSERT INTO specializations (name)
SELECT
  'Specialization ' || specialization_ids.id
FROM generate_series(1, 100) specialization_ids(id);


INSERT INTO companies (name)
SELECT
  'Company ' || company_ids.id
FROM generate_series(1, 1000) company_ids(id);


INSERT INTO resumes (
  title,
  user_id,
  area_id,
  specialization_id,
  compensation_from,
  compensation_to,
  created_at
)
WITH raw_resume_data AS (
  SELECT
    users.name || '''s resume' AS resume_title,
    users.id AS user_id,
    floor(10 + random() * 20) * 5000 AS base_compensation,
    floor(1 + random() * 10) * 5000 AS compensation_delta
  FROM users
)
SELECT
  rrd.resume_title,
  rrd.user_id,
  floor(1 + random() * 100)::int,
  floor(1 + random() * 100)::int,
  rrd.base_compensation,
  rrd.base_compensation + rrd.compensation_delta,
  NOW() - random() * INTERVAL '10 years'
FROM raw_resume_data AS rrd;


INSERT INTO vacancies (
  title,
  company_id,
  area_id,
  specialization_id,
  compensation_from,
  compensation_to,
  created_at
)
WITH raw_vacancy_data AS (
  SELECT
    companies.name || '''s vacancy #' || vacancy_numbers.number AS vacancy_title,
    companies.id AS company_id,
    floor(10 + random() * 20) * 5000 AS base_compensation,
    floor(1 + random() * 10) * 5000 AS compensation_delta
  FROM companies
  CROSS JOIN generate_series(1, 10) vacancy_numbers(number)
)
SELECT
  rvd.vacancy_title,
  rvd.company_id,
  floor(1 + random() * 100)::int,
  floor(1 + random() * 100)::int,  
  rvd.base_compensation,
  rvd.base_compensation + rvd.compensation_delta,
  NOW() - random() * INTERVAL '10 years'
FROM raw_vacancy_data AS rvd;


INSERT INTO applications (
  resume_id,
  vacancy_id,
  created_at
)
SELECT
  r.id,
  chosen_vacancies.id,
  base.ts + random() * (NOW() - base.ts)
FROM resumes AS r
CROSS JOIN LATERAL (
  SELECT DISTINCT
    vacancies.id,
    vacancies.created_at
  FROM (
    SELECT floor(1 + random() * 10000)::int AS idx
    FROM generate_series(1, 5)
    WHERE r.id IS NOT NULL
  ) AS idxs
  INNER JOIN vacancies
  ON vacancies.id = idxs.idx
) AS chosen_vacancies
CROSS JOIN LATERAL (
  SELECT GREATEST(r.created_at, chosen_vacancies.created_at) as ts
) AS base;








