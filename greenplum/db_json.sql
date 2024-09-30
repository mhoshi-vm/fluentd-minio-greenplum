CREATE EXTENSION pxf

CREATE EXTERNAL TABLE kube_logs(
  time TIMESTAMPTZ,
  stream TEXT,
  logtag TEXT,
  log TEXT,
  "docker.container_id" TEXT,
  kubernetes TEXT
)
LOCATION ('pxf://logs/kube-logs/2024/06/10/*.json.gz?PROFILE=s3:json&SERVER=s3srvcfg&S3_SELECT=AUTO&COMPRESSION_CODEC=gzip')
FORMAT 'CUSTOM' (FORMATTER='pxfwritable_import');

# Getting nested values
SELECT kubernetes::json->'container_name' as container_name from kube_logs;
