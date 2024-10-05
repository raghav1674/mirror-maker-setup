#!/usr/bin/env bash

sudo useradd kafka -d /opt/kafka -s /bin/bash

mkdir -p /opt/kafka/jdk/java17/

# wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.12%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.12_7.tar.gz
wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.12%2B7/OpenJDK17U-jre_aarch64_linux_hotspot_17.0.12_7.tar.gz
tar -xzf OpenJDK17U-jre_aarch64_linux_hotspot_17.0.12_7.tar.gz --strip-components 1 -C /opt/kafka/jdk/java17/
echo 'export JAVA_HOME=/opt/kafka/jdk/java17' >> /opt/kafka/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /opt/kafka/.bashrc

wget https://downloads.apache.org/kafka/3.7.1/kafka_2.13-3.7.1.tgz
tar -xzf kafka_2.13-3.7.1.tgz --strip-components 1 -C /opt/kafka/
echo 'export PATH=/opt/kafka/bin:$PATH' >> ~/.bashrc

wget https://github.com/mikefarah/yq/releases/download/v4.44.2/yq_linux_arm 
mv yq_linux_arm /usr/bin/yq
chmod +x /usr/bin/yq

yum install git -y

chown -R kafka:kafka /opt/kafka

tee /etc/sysctl.d/99-kafka.conf <<EOF
vm.swappiness = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.core.netdev_max_backlog = 1000
net.ipv4.tcp_window_scaling = 1
vm.overcommit_memory = 0
EOF

sysctl -p /etc/sysctl.d/99-kafka.conf


