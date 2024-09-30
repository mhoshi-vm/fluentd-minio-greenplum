CREATE EXTENSION pxf

CREATE EXTERNAL TABLE kube_csv_logs(
  time TIMESTAMPTZ,
  stream TEXT,
  logtag TEXT,
  log TEXT,
  docker TEXT,
  kubernetes TEXT
)
LOCATION ('pxf://logs/kube-logs/2024/06/10/*.csv.gz?PROFILE=s3:text&SERVER=s3srvcfg&S3_SELECT=ON&COMPRESSION_CODEC=gzip')
FORMAT 'CSV' ;

