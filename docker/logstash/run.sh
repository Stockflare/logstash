#!/bin/bash
EXTERNAL_CONFIG=${EXTERNAL_CONFIG:-}
EXTRA_CONFIG=${EXTRA_CONFIG:-}
ES_HOST=${ES_PORT_9200_TCP_ADDR:-127.0.0.1}
ES_PORT=${ES_PORT_9200_TCP_PORT:-9200}
EMBEDDED="false"

if [ "$ES_HOST" = "127.0.0.1" ] ; then
    EMBEDDED="true"
fi

if [ "$EXTERNAL_CONFIG" != "" ]; then
    cp /external_config/logstash.conf /opt/logstash.conf
else
    cat << EOF > /opt/logstash.conf
input {
  syslog {
    type => syslog
    port => 514
  }
}
output {
  stdout { }
EOF
    if [ "$EMBEDDED" = "true" ]; then
        cat << EOF >> /opt/logstash.conf
  elasticsearch { embedded => $EMBEDDED }
}
EOF
    else
        cat << EOF >> /opt/logstash.conf
  elasticsearch { embedded => $EMBEDDED host => "$ES_HOST" protocol => http port => "$ES_PORT" }
}
EOF
   fi
fi

if [ "$EXTRA_CONFIG" != "" ]; then
  cat /extra_config/*.conf >> /opt/logstash.conf
fi



/opt/logstash/bin/logstash agent -f /opt/logstash.conf -- web
