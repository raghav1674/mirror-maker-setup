CONNECT_HOST=http://<connector-ip>:8083

# MirrorSourceConnector
curl -X PUT -H "Content-Type: application/json" --data @configurations/mm2-msc-sasl-auth.json ${CONNECT_HOST}/connectors/mm2-msc/config

# MirrorCheckpointConnector
curl -X PUT -H "Content-Type: application/json" --data @configurations/mm2-cpc-sasl-auth.json ${CONNECT_HOST}/connectors/mm2-cpc/config

# MirrorHeartbeatConnector
curl -X PUT -H "Content-Type: application/json" --data @configurations/mm2-hbc-sasl-auth.json ${CONNECT_HOST}/connectors/mm2-hbc/config




