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
  region = var.region
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

resource "digitalocean_droplet" "jenkins" {
  image = "ubuntu-22-04-x64"
  name = "jenkins"
  region = var.region
  size = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.pc.id]
}

output "jenkins_ip" {
  value = digitalocean_droplet.jenkins.ipv4_address
}

data "digitalocean_ssh_key" "pc" {
  name = var.ssh_jenkins_key
}

# 
variable "do_token" {
  default = ""
  description = "Required | confira com https://cloud.digitalocean.com/account/api/tokens com sua conta da digitalocean"
}
# 
variable "kube_config_file" {
  default = "kube_config.yaml"
  description = "arquivo de configuração do kubectl para ligar o cluster para funcionar aponte o kubectl para ele"
}

variable "region" {
  default = "nyc1"
  description = "apenas para reusabilidade"
}

variable "ssh_jenkins_key" {
  default = "jenkins"
  description = "nome da chave ssh cadastrada em https://cloud.digitalocean.com/account/security"
}
