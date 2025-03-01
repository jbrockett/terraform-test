variable "namespace" {
  description = "Kubernetes namespace for the Nginx application"
  type        = string
  default     = "nginx"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "nginx"
}

variable "replicas" {
  description = "Number of replicas for the Nginx deployment"
  type        = number
  default     = 2
}

variable "image_name" {
  description = "Docker image name for Nginx"
  type        = string
  default     = "nginx"
}

variable "image_tag" {
  description = "Docker image tag for Nginx"
  type        = string
  default     = "1.25.3"
}

variable "container_port" {
  description = "Container port for Nginx"
  type        = number
  default     = 80
}

variable "resources" {
  description = "Resource limits and requests for the Nginx container"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "0.5"
      memory = "512Mi"
    }
    requests = {
      cpu    = "0.2"
      memory = "256Mi"
    }
  }
}

variable "service_type" {
  description = "Type of Kubernetes service to create"
  type        = string
  default     = "LoadBalancer"
}

variable "service_annotations" {
  description = "Annotations to add to the Kubernetes service"
  type        = map(string)
  default = {
    "service.beta.kubernetes.io/aws-load-balancer-type"            = "nlb"
    "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
    "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
  }
}

variable "service_ports" {
  description = "List of ports to expose through the service"
  type = list(object({
    name        = string
    port        = number
    target_port = number
    protocol    = string
  }))
  default = [
    {
      name        = "http"
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
  ]
}
