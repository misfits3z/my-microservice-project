variable "cluster_endpoint" {
  description = "EKS API server endpoint"
}

variable "cluster_ca" {
  description = "EKS cluster CA certificate (base64)"
}

variable "cluster_token" {
  description = "Auth token for EKS cluster"
}

variable "namespace" {
  description = "Namespace for Argo CD"
  default     = "argocd"
}

variable "chart_version" {
  description = "Argo CD Helm chart version"
  default     = "7.7.0"
}

# Для Helm-чарта, який створює ArgoCD Application
variable "app_repo_url" {
  description = "Git repo with Helm chart (your project repo)"
  default     = "https://github.com/misfits3z/my-microservice-project.git"
}

variable "app_revision" {
  description = "Git branch with Helm chart"
  default     = "lesson-8-9"
}

variable "app_path" {
  description = "Path to django-app Helm chart in repo"
  default     = "charts/django-app"
}
