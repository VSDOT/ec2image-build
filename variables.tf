variable "access-key" {
  description = "Access key to AWS console"
  type        = string
}
variable "secret-key" {
  description = "Secret key to AWS console"
  type        = string
}
variable "region" {
  description = "Enter your region"
  type        = string
}
variable "component-name" {
  description = "Enter your component-name"
  type        = string
}
variable "component-version" {
  description = "Enter your component-version"
  type        = string
}
variable "platform" {
  description = "Enter your platform"
  type        = string
}
variable "enable_key_rotation" {
  description = "Enter the enable_key_rotation"
  type        = bool
}
variable "instance_type" {
  description = "Enter your instance_type"
  type        = string
}
variable "security_group_ids" {
  description = "Enter your security_group_ids"
  type        = list
}
variable "subnet_id" {
  description = "Enter your subnet_id"
  type        = string
}