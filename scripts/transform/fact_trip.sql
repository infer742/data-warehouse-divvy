---- from https://stackoverflow.com/questions/7824831/generate-dates-between-date-ranges

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
select rideable_type, started_at, ended_at, DATEDIFF(minute, started_at, ended_at) as duration, 
    DATEDIFF(year, rider.birthday, started_at) as age_of_rider, DATEDIFF(year, rider.birthday, rider.start_date) as rider_age_account_start, rider.rider_id, payment.payment_id as payment_id,
    payment.date as payment_date_id, payment.account_number as account_id, start_station_id, end_station_id

from [dbo].[staging_trip] trip 
join [dbo].[staging_rider] rider on (trip.member_id = rider.rider_id)
join [dbo].[staging_payment] payment on (rider.rider_id = payment.account_number)
join [dbo].[staging_station] start_station on (trip.start_station_id = start_station.station_id)
join [dbo].[staging_station] end_station on (trip.end_station_id = end_station.station_id)

SELECT TOP 100 * FROM [dbo].[fact_trip]
GO
