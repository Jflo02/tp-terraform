
variable "containers" {
  type = map(object({
    container_name = string
    image_name     = string
    ports = object({
      internal = number
      external = number
    })
  }))
  default = {
    "nginx-terraform" = {
      container_name = "nginx-terraform"
      image_name     = "nginx:latest"
      ports          = { internal = 80, external = 8080 }
    },
    "client" = {
      container_name = "client"
      image_name     = "appropriate/curl"
      ports          = { internal = 80, external = 8081 }
    }
  }
}
