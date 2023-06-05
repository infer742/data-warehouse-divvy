 if NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'dlsfs_datalakeudacity_dfs_core_windows_net') 
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
    as
select account_number, member, start_date, end_date
from [dbo].[staging_payment] payment 
join [dbo].[staging_rider] rider on (payment.account_number = rider.rider_id)

SELECT TOP 100 * FROM [dbo].[dim_account]
GO
