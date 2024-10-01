CREATE EXTENSION pxf

CREATE EXTERNAL TABLE kube_logs(
  time TIMESTAMPTZ,
  stream TEXT,
  logtag TEXT,
  log TEXT,
  "docker.container_id" TEXT,
  kubernetes TEXT
)
LOCATION ('pxf://logs/kube-logs/2024/09/10/*.json.gz?PROFILE=s3:json&SERVER=s3srvcfg&S3_SELECT=AUTO&COMPRESSION_CODEC=gzip')
FORMAT 'CUSTOM' (FORMATTER='pxfwritable_import');

# Getting nested values
SELECT kubernetes::json->'container_name' as container_name from kube_logs;


# Write to a different location as parquet files
CREATE WRITABLE EXTERNAL TABLE kube_writable_logs(
  time TIMESTAMPTZ,
  stream TEXT,
  logtag TEXT,
  log TEXT,
  "docker.container_id" TEXT,
  kubernetes TEXT
)
LOCATION ('pxf://logs/output-logs/kube_writable_logs?PROFILE=s3:parquet&SERVER=s3srvcfg&S3_SELECT=AUTO&COMPRESSION_CODEC=gzip')
FORMAT 'CUSTOM' (FORMATTER='pxfwritable_export');

insert into kube_writable_logs ( select * from kube_logs );

CREATE EXTERNAL TABLE read_kube_writable_logs(
  time TIMESTAMPTZ,
  stream TEXT,
  logtag TEXT,
  log TEXT,
  "docker.container_id" TEXT,
  kubernetes TEXT
)
LOCATION ('pxf://logs/output-logs/kube_writable_logs?PROFILE=s3:parquet&SERVER=s3srvcfg&S3_SELECT=AUTO&COMPRESSION_CODEC=gzip')
FORMAT 'CUSTOM' (FORMATTER='pxfwritable_import');

