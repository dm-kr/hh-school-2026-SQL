WITH vacancies_by_months AS (
  SELECT
    DATE_TRUNC('month', created_at) AS month_ts,
    COUNT(*) AS vacancies_number
  FROM vacancies
  GROUP BY 1
  ORDER BY 2 DESC, 1 DESC
  LIMIT 1
),
resumes_by_months AS (
  SELECT
    DATE_TRUNC('month', created_at) AS month_ts,
    COUNT(*) AS resumes_number
  FROM resumes
  GROUP BY 1
  ORDER BY 2 DESC, 1 DESC
  LIMIT 1
)
SELECT
  TO_CHAR(vbm.month_ts, 'Month YYYY') AS month_with_most_vacancies,
  vbm.vacancies_number AS most_vacancies_number,
  TO_CHAR(rbm.month_ts, 'Month YYYY') AS month_with_most_resumes,
  rbm.resumes_number AS most_resumes_number
FROM vacancies_by_months AS vbm
CROSS JOIN resumes_by_months AS rbm;
