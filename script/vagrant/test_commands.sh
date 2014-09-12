docker run --name=kibana_run --env=ES_PORT_9200_TCP_ADDR:localhost --env=ES_PORT_9200_TCP_PORT:9200 --tty=true --interactive=true --detach=false --rm=true --publish=8800:8800 kibana /bin/bash


docker run --name=logstash_run --link=elasticsearch:es --tty=true --interactive=true --detach=false --rm=true --publish=514:514 --publish=9292:9292 logstash /bin/bash

docker run --name=logstash_run --link=elasticsearch:es --tty=true --interactive=true --detach=false --rm=true --publish=514:514 --publish=9292:9292 --env EXTERNAL_CONFIG=TRUE --volume=/vagrant/docker/logstash:/external_config logstash /bin/bash


docker run --name=logstash_run --link=elasticsearch:es --tty=true --interactive=true --detach=false --rm=true --publish=514:514 --publish=9292:9292 --env EXTRA_CONFIG=TRUE --volume=/vagrant/docker/logstash/extra_config_examples:/extra_config logstash /bin/bash

launcher stack create --name etcd --template ~/Development/stockflare/cloudformations/templates/etcd/etcd.cloudformation.json --region us-east-1

docker run --name=elasticsearch_logs --tty=true --interactive=true --detach=false --rm=true --volumes-from=elasticsearch ubuntu:trusty

docker run --name=logstash --detach=true --publish=514:514 --publish=9292:9292 --link=elasticsearch:es --env=EXTERNAL_CONFIG:/vagrant/docker/logstash/extra_config_examples/elasticsearch_logstash_example.conf --volumes-from=elasticsearch logstash/bin/bash

docker run --name=elasticsearch_test --tty=true --interactive=true --detach=false --rm=true elasticsearch /bin/bash


docker run --name=logstash_test --tty=true --interactive=true --detach=false --rm=true --link=elasticsearch:es --env EXTRA_CONFIG=true --volume=/vagrant/docker/logstash/extra_config_elasticsearch:/extra_config --volumes-from=elasticsearch logstash /bin/bash


docker run --name=elasticsearch_logstash_test --detach=true --publish=514:514 --env ES_PORT_9200_TCP_ADDR=internal-elasticse-ElasticL-VKESKIPG6J7U-1834718967.us-east-1.elb.amazonaws.com --env ES_PORT_9200_TCP_PORT=9200 --env EXTRA_CONFIG=true --volume=/home/ubuntu/logstash/elasticsearch:/extra_config --volumes-from=elasticsearch registry.stocktio.com:5000/stockflare/logstash:latest 
