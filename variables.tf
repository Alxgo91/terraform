variable "aws_region" {
    type = string
    default = "eu-west-3"
}

variable "my_instance_type" {
    type = string
    default = "t2.micro"
}

variable "vpc_id" {
    type = string
    default = "vpc-0ebcdb39f7a526ef9"
}

variable "subnet_id" {
    type = string
    default = "subnet-042a557a0a4d97456"
}