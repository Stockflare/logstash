#!/usr/bin/env bash
# Try to get lock to do the job
if [ `docker run stratmm/envy lock get --name elasticsearch_make_snapshot --ttl 900 --etcd_host 192.168.56.75` == 'true' ]
then
  echo 'Got Lock - Making Snapshot to S3'
  curl -XPUT "http://localhost:9200/_snapshot/s3_snapshot/$(date '+%Y_%m_%d_%H_%M_%S')" -d '{
    "type": "s3",
    "settings": {
        "bucket": "stockflare-elasticsearch-snapshots",
        "region": "us-east-1",
        "access_key": "XXX
        "secret_key": "XXXX"
    }
}'
  echo "Releasing the lock"
  docker run stratmm/envy lock release --name elasticsearch_make_snapshot  --etcd_host 192XX.168.56.75
else
  echo 'Did not get lock - not making snapshot'
fi
