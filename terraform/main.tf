terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
# -------------------------------------------------------------
  # Backend remoto do Terraform (boa prática)
  # -------------------------------------------------------------
  #
  # Em ambientes reais o arquivo terraform.tfstate não deve ficar
  # armazenado localmente.
  #
  # O ideal é utilizar um backend remoto como:
  # - AWS S3
  # - Azure Storage
  # - Google Cloud Storage
  #
  # Isso permite:
  # - colaboração entre equipes
  # - versionamento do state
  # - locking para evitar conflitos
  #
  # Exemplo com AWS S3:
  #
  # backend "s3" {
  #   bucket = "terraform-state-devops-test"
  #   key    = "devops-test/terraform.tfstate"
  #   region = "us-east-1"
  # }
  #
  # Neste projeto foi utilizado state local apenas para simplificar
  # a execução do teste, sem depender de credenciais cloud.
}

provider "docker" {}

resource "docker_image" "devops_test" {
  name = "devops-test:latest"

  build {
    context = "${path.module}/.."
  }
}

resource "docker_container" "devops_container" {
  name  = "devops-test-container"
  image = docker_image.devops_test.image_id

  ports {
    internal = 8080
    external = 8080
  }
}
