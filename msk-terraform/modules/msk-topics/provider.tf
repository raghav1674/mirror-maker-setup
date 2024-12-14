provider "kafka" {
  bootstrap_servers = local.bootstrap_servers
  tls_enabled       = true
  sasl_mechanism    = "aws-iam" // using AWS IAM for authentication
  sasl_aws_region   = local.region_name
}