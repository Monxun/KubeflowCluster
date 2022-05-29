variable "helm_release_name" {
  type = string
  default = "kubeflow"
}
variable "helm_repo" {
  type = string
  default = "https://us-east1-docker.pkg.dev/aline-jenkins-gcp/nightwalkers-helm"
}
variable "chart_name" {
    type = string
    default = "kubeflow"
}


provider "kubernetes" {
  load_config_file = "false"

  host     = google_container_cluster.primary.endpoint
  username = var.gke_username
  password = var.gke_password

  client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
  client_key             = google_container_cluster.primary.master_auth.0.client_key
  cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

# resource "helm_release" "kubeflow" {
#   name       = var.helm_release_name
#   repository = var.helm_repo
#   chart      = var.chart_name

#   values = [
#     "${file("helm-values.yaml")}"
#   ]

#   # set_sensitive {
#   #   name  = "DB_USERNAME"
#   #   value = local.aline_creds["DB_USERNAME"]
#   # }

# #   set_sensitive {
# #     name  = "DB_PASSWORD"
# #     value = local.aline_creds["DB_PASSWORD"]
# #   }

# #   set_sensitive {
# #     name  = "dbPort"
# #     value = local.aline_creds["DB_PORT"]
# #   }

# #   set_sensitive {
# #     name  = "DB_NAME"
# #     value = local.aline_creds["DB_NAME"]
# #   }

# #   set_sensitive {
# #     name  = "DB_HOST"
# #     value = local.aline_creds["DB_HOST"]
# #   }

# #   set_sensitive {
# #     name  = "APP_SERVICE_HOST"
# #     value = local.aline_creds["APP_SERVICE_HOST"]
# #   }

# #   set_sensitive {
# #     name  = "APP_USER_ACCESS_KEY"
# #     value = local.aline_creds["APP_USER_ACCESS_KEY"]
# #   }

# #   set_sensitive {
# #     name  = "ENCRYPT_SECRET_KEY"
# #     value = local.aline_creds["ENCRYPT_SECRET_KEY"]
# #   }

# #   set_sensitive {
# #     name  = "APP_USER_ACCESS_KEY"
# #     value = local.aline_creds["APP_USER_ACCESS_KEY"]
# #   }

# #   set_sensitive {
# #     name  = "S3_TEMPLATE_BUCKET"
# #     value = local.aline_creds["S3_TEMPLATE_BUCKET"]
# #   }

# }