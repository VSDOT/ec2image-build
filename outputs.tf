output "ec2-build_example_component_arn" {
  value = aws_imagebuilder_component.example_component.arn
}

output "distribution_configuration_myimage_id" {
    value = aws_imagebuilder_distribution_configuration.myimage.id
}

output "infrastructure_configuration_ec2_id" {
    value = aws_imagebuilder_infrastructure_configuration.ec2.id
}
output "aws_launch_template_id" {
  value = aws_launch_template.newtemp.id
}
output "aws_ami_arn" {
  value = aws_ami.myami.arn
}