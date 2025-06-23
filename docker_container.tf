resource "docker_container" "nginx" {
  name  = var.containers["nginx-terraform"].container_name
  image = docker_image.nginx.image_id
  ports {
    internal = var.containers["nginx-terraform"].ports["internal"]
    external = var.containers["nginx-terraform"].ports["external"]
  }

  networks_advanced {
    name = docker_network.private_network.name
    # aliases = "nginx"
  }
}

resource "docker_container" "client" {

  for_each = toset(["client-alpha", "client-beta", "client-gamma"])

  name  = "server-${each.value}"
  image = docker_image.client.name
  ports {
    internal = var.containers["client"].ports["internal"]
    external = var.containers["client"].ports["external"]
  }

  depends_on = [docker_container.nginx]

  command = [
    "/bin/sh", "-c",
    "curl -s http://nginx-terraform:80 && echo 'Nginx is reachable' || echo 'Nginx is not reachable'; sleep 15"
  ]
  networks_advanced {
    name = docker_network.private_network.name
  }
}
