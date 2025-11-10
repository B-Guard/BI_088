SELECT SUM(CASE WHEN servicecost < 0 THEN 1 ELSE 0 END)                          AS negative_costs,
       SUM(CASE WHEN servicequality < 1 OR servicequality > 5 THEN 1 ELSE 0 END) AS invalid_quality
FROM dwh_088.ft_serviceevent;