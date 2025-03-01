# Deploy Nginx application
module "nginx_app" {
  source = "../../../modules/k8s-apps/nginx"

  namespace   = "nginx-${var.environment}"
  app_name    = "nginx-${var.environment}"
  replicas    = var.nginx_replicas
  image_tag   = "1.27.4"
  
  resources = {
    limits = {
      cpu    = "0.5"
      memory = "512Mi"
    }
    requests = {
      cpu    = "0.2"
      memory = "256Mi"
    }
  }
  
  service_annotations = {
    "service.beta.kubernetes.io/aws-load-balancer-type"            = "nlb"
    "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
    "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
  }
  
  # Add explicit dependency on the EKS cluster and kubeconfig update
  depends_on = [
    module.eks,
    data.aws_eks_cluster.cluster,
    data.aws_eks_cluster_auth.cluster,
    null_resource.update_kubeconfig
  ]
}

# Example of another application that could be deployed
# module "app_backend" {
#   source = "../../../modules/k8s-apps/nginx"  # You would create a different module for your backend app

#   namespace   = "backend-${var.environment}"
#   app_name    = "backend-api"
#   replicas    = 3
#   image_name  = "my-backend-app"
#   image_tag   = "v1.0.0"
  
#   resources = {
#     limits = {
#       cpu    = "1.0"
#       memory = "1Gi"
#     }
#     requests = {
#       cpu    = "0.5"
#       memory = "512Mi"
#     }
#   }
  
#   service_type = "ClusterIP"  # Internal service
  
#   service_ports = [
#     {
#       name        = "http"
#       port        = 8080
#       target_port = 8080
#       protocol    = "TCP"
#     }
#   ]
# } 