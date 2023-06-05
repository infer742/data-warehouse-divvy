IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO


IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'dlsfs_datalakeudacity_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [dlsfs_datalakeudacity_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://dlsfs@datalakeudacity.dfs.core.windows.net' 
	)
GO;

CREATE EXTERNAL TABLE [dbo].[dim_rider] 
    WITH (
    LOCATION = 'dim_rider',
    DATA_SOURCE = [dlsfs_datalakeudacity_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
    )
AS SELECT rider.rider_id, address, first as first_name, last as last_name, birthday, 
  avg(num_rides) as avg_rides_month, avg(minutes_spent) as avg_time_spent_month
FROM [dbo].[staging_rider] rider 
JOIN [dbo].[view_aggs_rides] aggs on (rider_id = aggs.member_id)
group by rider_id, address, first, last, birthday;
GO


SELECT TOP 100 * FROM [dbo].[dim_rider]
GO