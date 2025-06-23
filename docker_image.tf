resource "docker_image" "nginx" {
  name         = var.containers["nginx-terraform"].image_name
  keep_locally = true
}

resource "docker_image" "client" {
  name         = var.containers["client"].image_name
  keep_locally = true
}