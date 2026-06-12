provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "git_security_group" {
    name   = "git_security_group_2cl"
    vpc_id = var.vpc_id

    tags = {
      name = "allow_gitsecurity"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.git_security_group.id
  ip_protocol       = "tcp" 
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ssh" {
  security_group_id = aws_security_group.git_security_group.id
  ip_protocol       = "tcp" 
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.git_security_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_key_pair" "alexandre_keypair" {
    key_name   = "alexandre_keypair"
    public_key = file("~/.ssh/terraform-ipssi.pub")
}

resource "aws_instance" "alexandre_serverweb" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.my_instance_type
  subnet_id = var.subnet_id
  key_name = aws_key_pair.alexandre_keypair.key_name
  vpc_security_group_ids = [aws_security_group.git_security_group.id]


  tags = {
    Name = "alexandre-terraform"
  }
}