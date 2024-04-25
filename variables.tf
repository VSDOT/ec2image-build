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

variable "subnet_id" {
  description = "Enter your subnet_id"
  type        = string
}
variable "user_data" {
  description = "upload your user_data file"
  type        = string
}
variable "root_device_name" {
  description = "Enter your root_device_name"
  type        = string
}
variable "volume_type" {
  description = "Enter your volume_type"
  type        = string
}
variable "encrypted" {
  description = "Enter your encrypted"
  type        = bool
}