 if NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'dlsfs_datalakeudacity_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [dlsfs_datalakeudacity_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://dlsfs@datalakeudacity.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE [dbo].[dim_trip_end_date]
    WITH (
    LOCATION = 'dim_trip_end_date',
    DATA_SOURCE = [dlsfs_datalakeudacity_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
    )
    as
select ended_at as date_id, ended_at as date, DATEPART(hour, ended_at) as hour, DATEPART(day, ended_at) as day, DATEPART(dw, ended_at) as day_of_week,
        DATEPART(week, ended_at) as week, DATEPART(month, ended_at) as month, DATEPART(quarter, ended_at) as quarter,
         DATEPART(year, ended_at) as year
         from [dbo].[staging_trip]

SELECT TOP 100 * FROM [dbo].[dim_trip_end_date]
GO
