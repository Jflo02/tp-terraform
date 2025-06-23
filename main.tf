terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}

resource "docker_network" "private_network" {
  name = "my_network"
}

resource "docker_image" "nginx" {
  name         = var.containers["nginx-terraform"].image_name
  keep_locally = true
}

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

output "nginx_container_id" {
  value = docker_container.nginx.id
}

data "http" "nginx" {
  depends_on = [docker_container.nginx]

  url = "http://localhost:${var.containers["nginx-terraform"].ports["external"]}"


  lifecycle {
    postcondition {
      condition     = can(regex("Welcome", self.response_body))
      error_message = "Nginx is not running or not accessible at http://localhost:${var.containers["nginx-terraform"].ports["external"]}"
    }
  }
}

resource "docker_image" "client" {
  name         = var.containers["client"].image_name
  keep_locally = true
}
resource "docker_container" "client" {
  name  = var.containers["client"].container_name
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
    # aliases = "client"
  }
}

# data "http" "client" {
#   url = "http://localhost:${var.containers["nginx-terraform"].ports["external"]}"


#   lifecycle {
#     postcondition {
#       condition     = can(regex("Welcome", self.response_body))
#       error_message = "Nginx curl not working}"
#     }
#   }
# }


