CREATE VIEW [dbo].[view_aggs_rides]
AS
SELECT member_id, MONTH(started_at) as month, YEAR(started_at) as year, count(*) as num_rides, AVG( DATEDIFF (minute, started_at, ended_at)) as minutes_spent
FROM [dbo].[staging_trip] 
GROUP by member_id, MONTH(started_at), YEAR(started_at);