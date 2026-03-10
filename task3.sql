SELECT
  areas.name AS area_name,
  ROUND(AVG(COALESCE(compensation_from, compensation_to)), 2) AS avg_compensation_from,
  ROUND(AVG(COALESCE(compensation_to, compensation_from)), 2) AS avg_compensation_to,  
  ROUND(
    AVG((
      COALESCE(compensation_from, compensation_to) +
      COALESCE(compensation_to, compensation_from)
    ) / 2.0),
    2
  ) AS avg_compensations_mean
FROM resumes
INNER JOIN areas ON area_id = areas.id
GROUP BY area_name
ORDER BY 4 DESC;