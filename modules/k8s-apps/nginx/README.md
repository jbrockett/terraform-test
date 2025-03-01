# Nginx Application Module

This module deploys an Nginx application to a Kubernetes cluster.

## Features

- Deploys a configurable Nginx deployment
- Creates a Kubernetes service with configurable ports
- Supports LoadBalancer service type with AWS NLB integration
- Fully parameterized for environment-specific configurations

## Usage

```hcl
module "nginx_app" {
  source = "../../../modules/k8s-apps/nginx"

  namespace   = "nginx-${var.environment}"
  app_name    = "nginx-${var.environment}"
  replicas    = 2
  image_tag   = "1.25.3"
  
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
  
  lb_controller_dependency = module.k8s_base.aws_lb_controller_status
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespace | Kubernetes namespace for the Nginx application | `string` | `"nginx"` | no |
| app_name | Name of the application | `string` | `"nginx"` | no |
| replicas | Number of replicas for the Nginx deployment | `number` | `2` | no |
| image_name | Docker image name for Nginx | `string` | `"nginx"` | no |
| image_tag | Docker image tag for Nginx | `string` | `"1.25.3"` | no |
| container_port | Container port for Nginx | `number` | `80` | no |
| resources | Resource limits and requests for the Nginx container | `object` | See variables.tf | no |
| service_type | Type of Kubernetes service to create | `string` | `"LoadBalancer"` | no |
| service_annotations | Annotations to add to the Kubernetes service | `map(string)` | See variables.tf | no |
| service_ports | List of ports to expose through the service | `list(object)` | See variables.tf | no |
| lb_controller_dependency | Dependency on the AWS Load Balancer Controller | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| lb_hostname | Hostname of the Network Load Balancer for the application |
| lb_ip | IP address of the Network Load Balancer for the application |
| namespace | Kubernetes namespace where the application is deployed |
| service_name | Name of the Kubernetes service |

## Dependencies

This module depends on:

1. A functioning Kubernetes cluster in Auto Mode 