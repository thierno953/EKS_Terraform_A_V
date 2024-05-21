variable "tf_public_subnets" {
  description = "Public Subnets"
  type        = list(any)
}

variable "tf_vpc_id" {
  description = "VPC ID"
  type        = string
  validation {
    condition     = length(var.tf_vpc_id) > 4 && substr(var.tf_vpc_id, 0, 4) == "vpc-"
    error_message = "VPC ID must not be empty."
  }
}

