variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "eks_cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "namespace" {
  type    = string
  default = "jenkins"
}

# variable "jenkins_chart_version" {
#   type    = string
#   default = "5.6.7"
# }
