terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
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
