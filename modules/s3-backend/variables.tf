variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state storage"
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table for state locking"
  type        = string
}