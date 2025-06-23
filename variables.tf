
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
      ports          = { internal = 80, external = null }
    }
  }
}

variable "ec2" {
    type = object({
      instance_type = string
      name           = string
    })
    default = {
      instance_type = "t2.micro"
      name           = "nginx-terraform-instance"
    }
}

variable "ec2-bdd" {
    type = object({
      instance_type = string
      name           = string
    })
    default = {
      instance_type = "t2.micro"
      name           = "bdd-terraform-instance"
    }
}

variable s3_bucket_name {
  type    = string
  default = "nginx-terraform-bucket"
}

variable sg_port_allow_http {
  type    = number
  default = 80
}
variable sg_port_allow_ssh {
  type    = number
  default = 22
}
variable sg_port_allow_all_outbound {
  type    = number
  default = 0
}

variable "number_of_clients" {
  type    = number
  default = 3
}


variable "machines" {
  type = list(object({
    name      = string
    vcpu      = number
    disk_size = number
    region    = string
  }))

  validation {
    condition = alltrue([
      for m in var.machines : m.vcpu >= 2 && m.vcpu <= 64
    ])
    error_message = "Chaque machine doit avoir entre 2 et 64 vCPU."
  }

  validation {
    condition = alltrue([
      for m in var.machines : m.disk_size >= 20
    ])
    error_message = "Chaque machine doit avoir une taille de disque d'au moins 20 Go."
  }


  validation {

    condition = alltrue([
      for m in var.machines : contains(["eu-west-1", "us-east-1", "ap-southeast-1"], m.region)
    ])
    error_message = "Chaque machine doit être dans une des régions autorisées : eu-west-1, us-east-1, ap-southeast-1]."
  }

  default = [{
    name      = "machine-1"
    vcpu      = 4
    disk_size = 50
    region    = "eu-west-1"
    },
    {
      name      = "machine-2"
      vcpu      = 8
      disk_size = 100
      region    = "us-east-1"
    },
    {
      name      = "machine-3"
      vcpu      = 16
      disk_size = 200
      region    = "ap-southeast-1"
  }]
}


