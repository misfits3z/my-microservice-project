output "s3_bucket_name" {
  value = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  value = module.s3_backend.dynamodb_table_name
}

#-------------EKS-----------------

output "eks_cluster_endpoint" {
  description = "EKS API endpoint for connecting to the cluster"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.eks_cluster_name
}

output "eks_node_role_arn" {
  description = "IAM role ARN for EKS Worker Nodes"
  value       = module.eks.eks_node_role_arn
}

# БД

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "rds_reader_endpoint" {
  value = module.rds.reader_endpoint
}

output "rds_port" {
  value = module.rds.port
}

output "rds_security_group" {
  value = module.rds.security_group_id
}

output "rds_subnet_group" {
  value = module.rds.db_subnet_group_name
}
