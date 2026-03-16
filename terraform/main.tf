provider "docker" {}

resource "docker_image" "devops_test" {
  name = "devops-test"
  build {
    context = ".."
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
