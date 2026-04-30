variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "IP allowed to ssh into EC2"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"

}