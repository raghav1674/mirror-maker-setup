#!/usr/bin/env bash

yum install -y wget docker

systemctl enable docker
systemctl start docker

mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.29.6/docker-compose-linux-aarch64 -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

useradd -m -s /bin/bash monitoring_user -d /opt/monitoring -G docker

tee /opt/monitoring/docker-compose.yml << EOF
services:
  kafka-exporter-source:
    image: danielqsj/kafka-exporter 
    command: 
      - --kafka.labels=cluster=source
%{ for key,value in source_exporter_args ~}
%{ if value != "" ~}
      - --${key}=${value}
%{ else ~}
      - --${key}
%{ endif ~}
%{ endfor ~}
    ports:
      - 9308:9308
  kafka-exporter-target:
    image: danielqsj/kafka-exporter 
    command: 
      - --kafka.labels=cluster=target
%{ for key,value in target_exporter_args ~}
%{ if value != "" ~}
      - --${key}=${value}
%{ else ~}
      - --${key}
%{ endif ~}
%{ endfor ~}
    ports:
      - 9309:9308
EOF

chown monitoring_user:monitoring_user /opt/monitoring/docker-compose.yml

su - monitoring_user -c "docker compose -f /opt/monitoring/docker-compose.yml up -d"

# Install Datadog Agent
tee /etc/yum.repos.d/datadog.repo <<EOF
[datadog]
name=Datadog, Inc.
baseurl=https://yum.datadoghq.com/stable/7/aarch64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public
       https://keys.datadoghq.com/DATADOG_RPM_KEY_B01082D3.public
       https://keys.datadoghq.com/DATADOG_RPM_KEY_FD4BF915.public
       https://keys.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public
EOF

yum install datadog-agent -y
sed "s/api_key:.*/api_key: ${dd_api_key}/" /etc/datadog-agent/datadog.yaml.example > /etc/datadog-agent/datadog.yaml
sed -i "s/# site:.*/site: ${dd_site}/" /etc/datadog-agent/datadog.yaml
chown dd-agent:dd-agent /etc/datadog-agent/datadog.yaml && chmod 640 /etc/datadog-agent/datadog.yaml

tee /etc/datadog-agent/conf.d/openmetrics.d/conf.yaml <<EOF
instances:
  - openmetrics_endpoint: http://localhost:9308/metrics
    metrics: [".*"]
    tag_by_endpoint: false

  - openmetrics_endpoint: http://localhost:9309/metrics
    metrics: [".*"]
    tag_by_endpoint: false
EOF

systemctl restart datadog-agent.service