variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.nano"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  default     = 2
}

variable "acl_value" {
    default = "private"
}