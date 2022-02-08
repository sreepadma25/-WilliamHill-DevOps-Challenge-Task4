#AutoScaling Launch Configuration
resource "aws_launch_configuration" "levelup-launchconfig" {
  name_prefix     = "levelup-launchconfig"
  image_id        = lookup(var.AMIS, var.AWS_REGION)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.levelup_key.key_name
  security_groups = [aws_security_group.levelup-instance.id]
  user_data       ="#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html" 

  lifecycle {
    create_before_destroy = true
  }
}

#Generate Key
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling Group
resource "aws_autoscaling_group" "scaleup-autoscaling" {
    count                  = var.ENABLE_AUTOSCALING ? 1 : 0
    name                   = "scaleup-autoscaling"
    vpc_zone_identifier    = ["subnet-9e0ad9f5", "subnet-d7a6afad"]
    launch_configuration   = aws_launch_configuration.levelup-launchconfig.name
    min_size               = 1
    max_size               = 2
    desired_capacity       = 1
    scaling_policy_type    = "RECURRENCE"
    scaling_policy_action = {
        operation = "ADD"
        instance_number = 2
    }
    scheduled_policy = {
         launch_time = "08:00"
     recurrence_type = "Daily"
          time_zone  = "UET"
    }

}

resource "aws_autoscaling_schedule" "scaledown_autoscaling" {
    count                  = var.ENABLE_AUTOSCALING ? 1 : 0
    name                   = "scaledown_autoscaling"
    min_size               = -1
    max_size               =  2
    desired_capacity       = -1
    scaling_policy_action = {
        operation = "REMOVE"
        instance_number = 2
    }
    scheduled_policy = {
         launch_time = "08:00"
     recurrence_type = "0 0 * * 1-5"
          time_zone  = "UET"
    }
}
