Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='BagDrop',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/BagDrop.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='BagDrop_QF_New',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/BagDrop_QF_New.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='BagDrop_QF_OBD',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/BagDrop_QF_OBD.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='BagDropDB_PER',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/BagDropDB_PER.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='BagDropDB_QF_BNE',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/BagDropDB_QF_BNE.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='BagDropDB_QF_SIN',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/BagDropDB_QF_SIN.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='CUSSBagDropDB_JQ',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/CUSSBagDropDB_JQ.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='CUSSBagDropDB_PER',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/CUSSBagDropDB_PER.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='CUSSBagDropDB_QF_New',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/CUSSBagDropDB_QF_New.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='CUSSReportingDB_JQ',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/CUSSReportingDB_JQ.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='CUSSReportingDB_PER',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/CUSSReportingDB_PER.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='CUSSReportingDB_QF_New',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/CUSSReportingDB_QF_New.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='ReportingDB',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/ReportingDB.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='ReportingDB_PER',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/ReportingDB_PER.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='ReportingDB_QF_BNE',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/ReportingDB_QF_BNE.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='ReportingDB_QF_New',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/ReportingDB_QF_New.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='ReportingDB_QF_OBD',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/ReportingDB_QF_OBD.bak',
@overwrite_S3_backup_file=1;

Use msdb;
exec msdb.dbo.rds_backup_database
@source_db_name='ReportingDB_QF_SIN',
@s3_arn_to_backup_to='arn:aws:s3:::icm.cloud.trail/Database Backups 17062021/ReportingDB_QF_SIN.bak',
@overwrite_S3_backup_file=1;

exec msdb..rds_task_status @task_id= <<task_ID>>
