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