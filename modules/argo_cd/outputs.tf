output "argocd_server_service" {
  description = "ArgoCD server service name"
  value       = "argocd-server"
}

output "argocd_namespace" {
  description = "Namespace where ArgoCD is installed"
  value       = var.namespace
}

output "how_to_get_admin_password" {
  description = "Command to get ArgoCD admin password"
  value       = "kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode"
}

output "how_to_port_forward" {
  description = "Command to port-forward ArgoCD UI to localhost:8080"
  value       = "kubectl -n ${var.namespace} port-forward svc/argocd-server 8080:80"
}
