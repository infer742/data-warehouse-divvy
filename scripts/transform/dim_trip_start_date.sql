 if NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'dlsfs_datalakeudacity_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [dlsfs_datalakeudacity_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://dlsfs@datalakeudacity.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE [dbo].[dim_trip_start_date]
    WITH (
    LOCATION = 'dim_trip_start_date',
    DATA_SOURCE = [dlsfs_datalakeudacity_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
    )
    as
select started_at as date_id, started_at as date, DATEPART(hour, started_at) as hour, DATEPART(day, started_at) as day, DATEPART(dw, started_at) as day_of_week,
        DATEPART(week, started_at) as week, DATEPART(month, started_at) as month, DATEPART(quarter, started_at) as quarter,
         DATEPART(year, started_at) as year
         from [dbo].[staging_trip]

SELECT TOP 100 * FROM [dbo].[dim_trip_start_date]
GO
