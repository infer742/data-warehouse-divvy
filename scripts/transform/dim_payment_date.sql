 if NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'dlsfs_datalakeudacity_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [dlsfs_datalakeudacity_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://dlsfs@datalakeudacity.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE [dbo].[dim_payment_date]
    WITH (
    LOCATION = 'dim_date',
    DATA_SOURCE = [dlsfs_datalakeudacity_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
    )
    as
select date as date_id, date, DATEPART(hour, date) as hour, DATEPART(day, date) as day, DATEPART(dw, date) as day_of_week,
        DATEPART(week, date) as week, DATEPART(month, date) as month, DATEPART(quarter, date) as quarter,
         DATEPART(year, date) as year
         from [dbo].[staging_payment]

SELECT TOP 100 * FROM [dbo].[dim_payment_date]
GO
