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
GO

CREATE EXTERNAL TABLE [dbo].[dim_account]
    WITH (
    LOCATION = 'dim_account',
    DATA_SOURCE = [dlsfs_datalakeudacity_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
    )
AS SELECT rider_id as account_number, rider.member, rider.start_date, rider.end_date
FROM [dbo].[staging_rider] rider
GO


SELECT TOP 100 * FROM [dbo].[dim_account]
GO