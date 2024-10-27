# For internal communication between brokers
resource "aws_security_group" "internal" {
  name        = "${var.cluster_name}-internal-sg"
  description = "For internal communication between brokers"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_inter_broker_access" {
  for_each                     = local.broker_ports
  security_group_id            = aws_security_group.internal.id
  referenced_security_group_id = aws_security_group.internal.id
  ip_protocol                  = "tcp"
  from_port                    = each.key
  to_port                      = each.key
  description                  = each.value
}

resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id            = aws_security_group.internal.id
  referenced_security_group_id = aws_security_group.internal.id
  ip_protocol                  = "-1"
}


# For monitoring
resource "aws_security_group" "monitoring" {
  name        = "${var.cluster_name}-monitoring-sg"
  description = "For monitoring"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_monitoring" {
  for_each          = local.monitoring_rules
  security_group_id = aws_security_group.monitoring.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  description       = each.value.description
}


# For client to broker communication
resource "aws_security_group" "external" {
  name        = "${var.cluster_name}-external-sg"
  description = "For client to broker communication"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_inter_broker_access" {
  for_each          = local.client_broker_rules
  security_group_id = aws_security_group.internal.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  description       = each.value.description
}


# For additional client to broker communication
resource "aws_security_group" "additional" {
  name        = "${var.cluster_name}-additional-sg"
  description = "For additional client communication"
  vpc_id      = var.vpc_id
}

