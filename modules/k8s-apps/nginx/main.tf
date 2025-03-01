resource "kubernetes_namespace" "nginx" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.nginx.metadata[0].name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          image = "${var.image_name}:${var.image_tag}"
          name  = var.app_name

          port {
            container_port = var.container_port
          }

          resources {
            limits = {
              cpu    = var.resources.limits.cpu
              memory = var.resources.limits.memory
            }
            requests = {
              cpu    = var.resources.requests.cpu
              memory = var.resources.requests.memory
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.nginx.metadata[0].name
    annotations = var.service_annotations
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec[0].template[0].metadata[0].labels.app
    }

    dynamic "port" {
      for_each = var.service_ports
      content {
        name        = port.value.name
        port        = port.value.port
        target_port = port.value.target_port
        protocol    = port.value.protocol
      }
    }

    type = var.service_type

    load_balancer_class = "eks.amazonaws.com/nlb"
  }

  lifecycle {
    ignore_changes = [
      spec.0.load_balancer_class,
      spec.0.cluster_ip,
      spec.0.cluster_ips,
      spec.0.external_traffic_policy,
      spec.0.health_check_node_port,
      spec.0.ip_families,
      spec.0.ip_family_policy,
      spec.0.internal_traffic_policy,
      spec.0.port.0.node_port
    ]
  }
} 