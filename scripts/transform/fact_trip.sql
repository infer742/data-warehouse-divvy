
 if NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'dlsfs_datalakeudacity_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [dlsfs_datalakeudacity_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://dlsfs@datalakeudacity.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE [dbo].[fact_trip]
    WITH (
    LOCATION = 'fact_trip',
    DATA_SOURCE = [dlsfs_datalakeudacity_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
    )
    as
select trip.trip_id as trip_id, rideable_type, started_at as start_date_id, ended_at as end_date_id, DATEDIFF(minute, started_at, ended_at) as duration, 
    DATEDIFF(year, rider.birthday, started_at) as age_of_rider, rider.rider_id, start_station_id, end_station_id

from [dbo].[staging_trip] trip 
join [dbo].[staging_rider] rider on (trip.member_id = rider.rider_id)
join [dbo].[staging_station] start_station on (trip.start_station_id = start_station.station_id)
join [dbo].[staging_station] end_station on (trip.end_station_id = end_station.station_id)

SELECT TOP 100 * FROM [dbo].[fact_trip]
GO
