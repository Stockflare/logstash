#!/usr/bin/env bash
# Try to get lock to do the job
if [ `docker run stratmm/envy lock get --name elasticsearch_set_snapshot --ttl 3600 --etcd_host 192.168.56.75` == 'true' ]
then
  echo 'Got Lock - Adding Snapshot to cluster'
  curl -XPUT 'http://localhost:9200/_snapshot/s3_snapshot' -d '{
    "type": "s3",
    "settings": {
        "bucket": "stockflare-elasticsearch-snapshots",
        "region": "us-east-1",
        "access_key": "xxxx",
        "secret_key": "xxxxxx"
    }
}'
  echo "Releasing the lock"
  docker run stratmm/envy lock release --name elasticsearch_set_snapshot  --etcd_host 192.168.56.75
else
  echo 'Did not get lock - not adding snapshot'
fi
