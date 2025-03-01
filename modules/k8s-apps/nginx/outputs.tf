output "lb_hostname" {
  description = "Hostname of the Network Load Balancer for the application"
  value       = try(kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname, null)
}

output "lb_ip" {
  description = "IP address of the Network Load Balancer for the application"
  value       = try(kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.ip, null)
}

output "namespace" {
  description = "Kubernetes namespace where the application is deployed"
  value       = kubernetes_namespace.nginx.metadata[0].name
}

output "service_name" {
  description = "Name of the Kubernetes service"
  value       = kubernetes_service.nginx.metadata[0].name
} 