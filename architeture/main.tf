# link de referência oficial da hashicorp e seu parceiro digital ocean
# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "meucluster" {
  name = "meucluster"
  region = "nyc1"
  version = "1.24.4-do.0"

  node_pool {
    name = "default"
    size = "s-2vcpu-2gb"
    node_count = 2
  }
}

resource "local_sensitive_file" "kube_config" {
  content = digitalocean_kubernetes_cluster.meucluster.kube_config.0.raw_config
  filename = var.kube_config_file
}

variable "do_token" {
  default = ""
}

variable "kube_config_file" {
  default = "kube_config.yaml"
}