
variable "ec2" {
  type = object({
    instance_type = string
    name          = string
  })
  default = {
    instance_type = "t2.micro"
    name          = "nginx-terraform-instance"
  }
}

variable "sg_port_allow_http" {
  type    = number
  default = 80
}
variable "sg_port_allow_ssh" {
  type    = number
  default = 22
}
variable "sg_port_allow_all_outbound" {
  type    = number
  default = 0
}