# Create a security group for the EC2 instance
resource "aws_security_group" "web" {
  name        = "nginx-sg"
  description = "Allow web and SSH traffic"

  ingress {
    from_port   = var.sg_port_allow_http
    to_port     = var.sg_port_allow_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }

  ingress {
    from_port   = var.sg_port_allow_ssh
    to_port     = var.sg_port_allow_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH traffic"
  }

  egress {
    from_port   = var.sg_port_allow_all_outbound
    to_port     = var.sg_port_allow_all_outbound
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "nginx-sg"
  }
}
