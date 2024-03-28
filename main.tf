# resource "aws_iam_role" "ec2_image_build_role" {
#   name               = "EC2ImageBuildRole"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }
# resource "aws_iam_policy" "ec2_image_build_policy" {
#   name        = "EC2ImageBuildPolicy"
#   description = "Policy for EC2 image building"
 
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:CreateImage",
#         "ec2:DescribeImages",
#         "ssm:UpdateInstanceInformation",
#         "ssmmessages:CreateControlChannel",
#         "ssmmessages:CreateDataChannel",
#         "ssmmessages:OpenControlChannel",
#         "ssmmessages:OpenDataChannel",
#         "ec2:RegisterImage"
#       ],
#       "Resource": "arn:aws:ec2:region:account-id:instance/instance-id"
#     }
#   ]
# }
# EOF
# }
# data "aws_partition" "current" {}
# data "aws_region" "current" {}

# #kms key
# resource "aws_kms_key" "fail" {
#   description = "myawskey"
#   enable_key_rotation    = var.enable_key_rotation
# }

# resource "aws_kms_key_policy" "example" {
#   key_id = aws_kms_key.fail.id
#   policy = jsonencode({
#     Id = "example"
#     Statement = [
#       {
#         Action = "kms:*"
#         Effect = "Allow"
#         Principal = {
#           AWS = "*"
#         }

#         Resource = "*"
#         Sid      = "Enable IAM User Permissions"
#       },
#     ]
#     Version = "2012-10-17"
#   })
# }

# #imagebuilder component
# resource "aws_imagebuilder_component" "example_component" {
#   name          = var.component-name
#   version       = var.component-version
#   platform      = var.platform
#   kms_key_id    = aws_kms_key.fail.arn
#   #"arn:aws:kms:us-east-1:891376931947:key/5f1212a4-500a-4ace-95a2-e34bf14edd53" 
#  data = yamlencode({
#     phases = [{
#       name = "build"
#       steps = [{
#         action = "ExecuteBash"
#         inputs = {
#           commands = ["echo 'hello world'"]
#         }
#         name      = "example"
#         onFailure = "Continue"
#       }]
#     }]
#     schemaVersion = 1.0
#   })
# }
# #Image recipes
# resource "aws_imagebuilder_image_recipe" "example_recipe" {
#   name          = "example-recipe"
#   parent_image  = "arn:${data.aws_partition.current.partition}:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-2-x86/x.x.x"
#   version       = "1.0.0"
#    block_device_mapping {
#     device_name = "/dev/xvdb"

#     ebs {
#       encrypted             = true
#       kms_key_id = aws_kms_key.fail.arn
#       delete_on_termination = true
#       volume_size           = 100
#       volume_type           = "gp2"
#     }
#   }
#   component {
#     component_arn = aws_imagebuilder_component.example_component.arn
#   }
# }
# #infrastructure_configuration
# resource "aws_imagebuilder_infrastructure_configuration" "ec2" {
#   description                   = "example description"
#   instance_profile_name         = aws_iam_instance_profile.image_builder_instance_profile.name
#   instance_types                = toset([var.instance_type])
#   key_pair                      = aws_key_pair.deployer.key_name
#   name                          = "ec2-1"
#   security_group_ids            = var.security_group_ids
#  # sns_topic_arn                 = aws_sns_topic.user_updates.arn
#   subnet_id                     = var.subnet_id
#   terminate_instance_on_failure = true

#   logging {
#     s3_logs {
#       s3_bucket_name = "my imagebuc"
#       s3_key_prefix  = "logs"
#     }
#   }

#   tags = {
#     foo = "bar"
#   }
# }
# #Distribution settings
# resource "aws_imagebuilder_distribution_configuration" "myimage" {
#   name = "example"

#   distribution {
#     ami_distribution_configuration {
#       kms_key_id = aws_kms_key.fail.arn
#       ami_tags = {
#         CostCenter = "IT"
#       }

#       name = "example-{{ imagebuilder:buildDate }}"

#       launch_permission {
#         user_ids = ["891376931947"]
#       }
#     }

#     launch_template_configuration {
#       launch_template_id = aws_launch_template.newtemp.id
#     }

#     region = "us-east-1"
#   }
# }
# #x
# resource "aws_imagebuilder_image_pipeline" "my_pipeline" {
#   name                = "example-pipeline"
#   description         = "Example Image Builder Pipeline"
#   image_recipe_arn                 = aws_imagebuilder_image_recipe.example_recipe.arn
#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.ec2.arn
#   distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.myimage.arn
# }
# #keypair
# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 vs123@gmail.com"
# }
# resource "aws_iam_instance_profile" "image_builder_instance_profile" {
#   name = "test"
#   role = aws_iam_role.ec2_image_build_role.name
# }
# #ec2
# resource "aws_instance" "example" {
#   ami           = aws_ami.myami.id  
#   instance_type = var.instance_type
#   key_name      = aws_key_pair.deployer.id 
#   iam_instance_profile = aws_iam_instance_profile.image_builder_instance_profile.name           
#   subnet_id     = var.subnet_id  
#   monitoring    = true    
#   ebs_optimized = true
#   associate_public_ip_address = false
  

#   ebs_block_device {
#     encrypted   = true
#     device_name = "/dev/xvda"
#     kms_key_id  = aws_kms_key.fail.arn
#     volume_type = "gp2"
#     volume_size = 20
#   }
#   metadata_options {
#     http_endpoint = "enabled"
#     http_tokens   = "required"
#   } 
#   tags = {
#     Name = "my-instance"
#   }
# }
# #ami
# resource "aws_ami" "myami" {
#   name               = "ec2-ami"
#   virtualization_type = "hvm"
#   root_device_name   = "/dev/xvda"
#   ebs_block_device {
#     device_name = "/dev/xvda"
#     snapshot_id  = aws_ebs_snapshot.example_snapshot.id
#     volume_type = "gp2"
#     volume_size = 20
#     delete_on_termination = true
#   }
#   tags = {
#     Name = "example-ami"
#   }
# }
# #snapshot
# resource "aws_ebs_volume" "example" {
#   availability_zone = "us-east-1a"
#   kms_key_id        = aws_kms_key.fail.arn
#   encrypted         = true
#   size              = 20 
#   type              = "gp2" 

#   tags = {
#     Name = "HelloWorld"
#   }
# }
# resource "aws_ebs_snapshot" "example_snapshot" {
#   volume_id = aws_ebs_volume.example.id

#   tags = {
#     Name = "HelloWorld_snap"
#   }
# }
# #launch_template
# resource "aws_launch_template" "newtemp" {
#   name_prefix   = "my-lt"
#   image_id      = aws_ami.myami.id
#   instance_type = "t2.micro"
#   #associate_public_ip_address = true

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       encrypted             = true
#       kms_key_id            = aws_kms_key.fail.arn
#       delete_on_termination = true
#       volume_size           = 100
#       volume_type           = "gp2"
#     }
#   }
#   network_interfaces {
#     device_index         = 0
#     associate_public_ip_address = false
#   }
#   metadata_options {
#     http_endpoint = "enabled"
#     http_tokens   = "required"
#   } 
#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "my-instance"
#     }
#   }
# }













































resource "aws_iam_role" "ec2_image_build_role" {
  name               = "EC2ImageBuildRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_policy" "ec2_image_build_policy" {
  name        = "EC2ImageBuildPolicy"
  description = "Policy for EC2 image building"
 
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateImage",
        "ec2:DescribeImages",
        "ssm:UpdateInstanceInformation",
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel",
        "ec2:RegisterImage"
      ],
      "Resource": "arn:aws:ec2:region:account-id:instance/instance-id"
    }
  ]
}
EOF
}
data "aws_partition" "current" {}
data "aws_region" "current" {}

#kms key
resource "aws_kms_key" "fail" {
  description = "myawskey"
  enable_key_rotation    = var.enable_key_rotation
}

resource "aws_kms_key_policy" "example" {
  key_id = aws_kms_key.fail.id
  policy = jsonencode({
    Id = "example"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }

        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

#imagebuilder component
resource "aws_imagebuilder_component" "example_component" {
  name          = var.component-name
  version       = var.component-version
  platform      = var.platform
  kms_key_id    = aws_kms_key.fail.arn
  #"arn:aws:kms:us-east-1:891376931947:key/5f1212a4-500a-4ace-95a2-e34bf14edd53" 
 data = yamlencode({
    phases = [{
      name = "build"
      steps = [{
        action = "ExecuteBash"
        inputs = {
          commands = ["echo 'hello world'"]
        }
        name      = "example"
        onFailure = "Continue"
      }]
    }]
    schemaVersion = 1.0
  })
}
#Image recipes
resource "aws_imagebuilder_image_recipe" "example_recipe" {
  name          = "example-recipe"
  parent_image  = "arn:${data.aws_partition.current.partition}:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-2-x86/x.x.x"
  version       = "1.0.0"
   block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      encrypted             = true
      kms_key_id = aws_kms_key.fail.arn
      delete_on_termination = true
      volume_size           = 100
      volume_type           = "gp2"
    }
  }
  component {
    component_arn = aws_imagebuilder_component.example_component.arn
  }
}
#infrastructure_configuration
resource "aws_imagebuilder_infrastructure_configuration" "ec2" {
  description                   = "example description"
  instance_profile_name         = aws_iam_instance_profile.image_builder_instance_profile.name
  instance_types                = toset([var.instance_type])
  key_pair                      = aws_key_pair.deployer.key_name
  name                          = "ec2-1"
  security_group_ids            = var.security_group_ids
 # sns_topic_arn                 = aws_sns_topic.user_updates.arn
  subnet_id                     = var.subnet_id
  terminate_instance_on_failure = true

  logging {
    s3_logs {
      s3_bucket_name = "my imagebuc"
      s3_key_prefix  = "logs"
    }
  }

  tags = {
    foo = "bar"
  }
}
#Distribution settings
resource "aws_imagebuilder_distribution_configuration" "myimage" {
  name = "example"

  distribution {
    ami_distribution_configuration {
      kms_key_id = aws_kms_key.fail.arn
      ami_tags = {
        CostCenter = "IT"
      }

      name = "example-{{ imagebuilder:buildDate }}"

      launch_permission {
        user_ids = ["891376931947"]
      }
    }

    launch_template_configuration {
      launch_template_id = aws_launch_template.newtemp.id
    }

    region = "us-east-1"
  }
}
#x
resource "aws_imagebuilder_image_pipeline" "my_pipeline" {
  name                = "example-pipeline"
  description         = "Example Image Builder Pipeline"
  image_recipe_arn    = aws_imagebuilder_image_recipe.example_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.ec2.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.myimage.arn
}
#keypair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}
resource "aws_iam_instance_profile" "image_builder_instance_profile" {
  name = "ImageBuilderInstanceProfile"
  role = aws_iam_role.ec2_image_build_role.name
}
#ec2
resource "aws_instance" "example" {
  ami           = aws_ami.myami.id  
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.id    # Replace with your key pair name
  subnet_id     = var.subnet_id      

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    volume_size = 20
  }

  tags = {
    Name = "example-instance"
  }
}
#ami
resource "aws_ami" "myami" {
  name               = "ec2-ami"
  virtualization_type = "hvm"
  root_device_name   = "/dev/xvda"
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id  = aws_ebs_snapshot.example_snapshot.id
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = true
  }
  tags = {
    Name = "example-ami"
  }
}
#snapshot
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 20 
  type              = "gp2" 

  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.example.id

  tags = {
    Name = "HelloWorld_snap"
  }
}
#launch_template
resource "aws_launch_template" "newtemp" {
  name_prefix   = "my-lt"
  image_id      = aws_ami.myami.id
  instance_type = "t2.micro"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      encrypted             = true
      kms_key_id            = aws_kms_key.fail.arn
      delete_on_termination = true
      volume_size           = 100
      volume_type           = "gp2"
    }
  }

  network_interfaces {
    device_index         = 0
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "my-instance"
    }
  }
}



