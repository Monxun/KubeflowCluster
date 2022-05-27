# Kubernetes provider
# https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster#optional-configure-terraform-kubernetes-provider
# To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes

# The Kubernetes provider is included in this file so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
# You should **not** schedule deployments and services in this workspace. This keeps workspaces modular (one for provision EKS, another for scheduling Kubernetes resources) as per best practices.

#  provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }


provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

# data "aws_secretsmanager_secret" "alinekeys" {
#   name = "aline-financial-mg/microservice-secrets"
# }

# data "aws_secretsmanager_secret_version" "aline_creds_version" {
#   secret_id     = data.aws_secretsmanager_secret.alinekeys.id
#   version_stage = "AWSCURRENT"
# }

# locals {
#   aline_creds = jsondecode(data.aws_secretsmanager_secret_version.aline_creds_version.secret_string)
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.cluster.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1alpha1"
#       args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
#       command     = "aws"
#     }
#   }
# }

# resource "helm_release" "aline-financial" {
#   name       = "aline-financial"
#   chart      = "./helm/aline-financial"
#   namespace  = "dev"
#   create_namespace = true

#   values = [
#     "${file("helm-values.yaml")}"
#   ]

#   set_sensitive {
#     name  = "imageRepo"
#     value = var.image_repo
#   }

#   set_sensitive {
#     name  = "Secrets.DB_USERNAME"
#     value = local.aline_creds["DB_USERNAME"]
#   }

#   set_sensitive {
#     name  = "Secrets.DB_PASSWORD"
#     value = local.aline_creds["DB_PASSWORD"]
#   }

#   set_sensitive {
#     name  = "dbPort"
#     value = local.aline_creds["DB_PORT"]
#   }

#   set_sensitive {
#     name  = "Secrets.DB_NAME"
#     value = local.aline_creds["DB_NAME"]
#   }

#   set_sensitive {
#     name  = "Secrets.DB_HOST"
#     value = local.aline_creds["DB_HOST"]
#   }

#   set_sensitive {
#     name  = "Secrets.APP_SERVICE_HOST"
#     value = local.aline_creds["APP_SERVICE_HOST"]
#   }

#   set_sensitive {
#     name  = "Secrets.APP_USER_ACCESS_KEY"
#     value = local.aline_creds["APP_USER_ACCESS_KEY"]
#   }

#   set_sensitive {
#     name  = "Secrets.ENCRYPT_SECRET_KEY"
#     value = local.aline_creds["ENCRYPT_SECRET_KEY"]
#   }

#   set_sensitive {
#     name  = "Secrets.APP_USER_SECRET_KEY"
#     value = local.aline_creds["APP_USER_SECRET_KEY"]
#   }

#   set_sensitive {
#     name  = "Secrets.S3_TEMPLATE_BUCKET"
#     value = local.aline_creds["S3_TEMPLATE_BUCKET"]
#   }

# }