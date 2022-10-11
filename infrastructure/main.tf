# Security group for the EC2 Instance
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-ec2_sg"
  description = "Security group for EC2 instances"

  tags = {
    Name    = "${var.project}-sg"
    project = var.project
  }

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "for all outgoing traffics"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# AWS key pair
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws_key_pair_ec2" {
  key_name   = "${var.project}"
  public_key = tls_private_key.private_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.private_key.private_key_pem}' > ./keys/${var.project}.pem"
  }
}

# EC2 Instance
resource "aws_instance" "api_instance" {

  ami                    = "ami-052efd3df9dad4825"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.aws_key_pair_ec2.key_name
  user_data              = <<-EOF
    #!/bin/bash
    cd /home/ubuntu

    sudo apt update
    sudo apt install python3-pip
    sudo snap install docker

    curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    git clone https://github.com/raib100/nrc2136-g7

    cd nrc2136-g7
  EOF

  tags = {
    Name    = "${var.project}-ec2"
    project = var.project
  }
}
