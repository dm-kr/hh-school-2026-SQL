SELECT
  v.id,
  v.title,
  COUNT(*) AS total
FROM vacancies AS v
INNER JOIN applications AS a ON v.id = a.vacancy_id
  AND a.created_at <= v.created_at + INTERVAL '7 days'
GROUP BY v.id, v.title
HAVING COUNT(*) > 5
ORDER BY total DESC;