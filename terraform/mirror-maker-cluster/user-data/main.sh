#!/usr/bin/env bash

yum install wget -y

sudo useradd kafka -d /opt/kafka -s /bin/bash

mkdir -p /opt/kafka/jdk/java17/

wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.12%2B7/OpenJDK17U-jre_aarch64_linux_hotspot_17.0.12_7.tar.gz
tar -xzf OpenJDK17U-jre_aarch64_linux_hotspot_17.0.12_7.tar.gz --strip-components 1 -C /opt/kafka/jdk/java17/
echo 'export JAVA_HOME=/opt/kafka/jdk/java17' >> /opt/kafka/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /opt/kafka/.bashrc

wget https://downloads.apache.org/kafka/3.7.1/kafka_2.13-3.7.1.tgz
tar -xzf kafka_2.13-3.7.1.tgz --strip-components 1 -C /opt/kafka/
echo 'export PATH=/opt/kafka/bin:$PATH' >> ~/.bashrc

wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/1.0.1/jmx_prometheus_javaagent-1.0.1.jar
wget https://raw.githubusercontent.com/aws-samples/mirrormaker2-msk-migration/refs/heads/master/kafka-connect.yml

mv kafka-connect.yml /opt/kafka/
mv jmx_prometheus_javaagent-1.0.1.jar /opt/kafka/

wget https://github.com/mikefarah/yq/releases/download/v4.44.2/yq_linux_arm 
mv yq_linux_arm /usr/bin/yq
chmod +x /usr/bin/yq

tee /etc/sysctl.d/99-kafka.conf <<EOF
vm.swappiness = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.core.netdev_max_backlog = 1000
net.ipv4.tcp_window_scaling = 1
vm.overcommit_memory = 0
EOF

sysctl -p /etc/sysctl.d/99-kafka.conf

mkdir -p /opt/kafka/{libs,connectors,logs,config}

sudo tee /opt/kafka/config/connect-distributed.properties <<EOF

bootstrap.servers=${bootstrap_servers}
group.id=connect-cluster-${cluster_suffix}


key.converter=org.apache.kafka.connect.json.JsonConverter
value.converter=org.apache.kafka.connect.json.JsonConverter

key.converter.schemas.enable=true
value.converter.schemas.enable=true

internal.key.converter=org.apache.kafka.connect.json.JsonConverter
internal.value.converter=org.apache.kafka.connect.json.JsonConverter
internal.key.converter.schemas.enable=false
internal.value.converter.schemas.enable=false

# this config for dirtributed
offset.storage.topic=connect-offsets-${cluster_suffix}
offset.storage.replication.factor=1


config.storage.topic=connect-configs-${cluster_suffix}
config.storage.replication.factor=1

status.storage.topic=connect-status-${cluster_suffix}
status.storage.replication.factor=1

listeners=HTTP://:8083

plugin.path=/opt/kafka/libs,/opt/kafka/connectors,

%{ for key,value in kafka_connect_properties ~}
${key}=${value}
%{ endfor ~}
EOF

sudo chown -R kafka:kafka  /opt/kafka

sudo tee /etc/systemd/system/kafka-connect.service <<EOF
[Unit]
Description=Kafka Connect
After=network.target

[Service]
Type=simple
User=kafka
Group=kafka
Environment="JAVA_HOME=/opt/kafka/jdk/java17"
Environment="KAFKA_OPTS=-javaagent:/opt/kafka/jmx_prometheus_javaagent-1.0.1.jar=3600:/opt/kafka/kafka-connect.yml"
Environment="KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:/opt/kafka/config/connect-log4j.properties"
Environment="KAFKA_HEAP_OPTS=-Xmx2G -Xms2G"
Environment="LOG_DIR=/opt/kafka/logs"
ExecStart=/opt/kafka/bin/connect-distributed.sh /opt/kafka/config/connect-distributed.properties
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable kafka-connect
sudo systemctl start kafka-connect

