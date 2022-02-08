variable "AWS_ACCESS_KEY" {
    type = string
    default = "AKIARC36NGC5PBK7TBHH"
}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
default = "eu-west-2"
}

variable "AMIS" {
    type = map
    default = {
        eu-west-1 = "ami-08ca3fed11864d6bb"
        eu-west-2 = "ami-0015a39e4b7c0966f"
        eu-west-3 = "ami-0673982fbc513b35a"
     }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "levelup_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "levelup_key.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "ENABLE_AUTOSCALING" {
  description = "If set to true, enable auto scaling"
  type        = bool
}