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

variable "ingress_rules" {
  type = list(object({
    port        = number
    proto       = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      port        = 80
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 22
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 8080
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 9000
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 9090
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 9100
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 3000
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 3306
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}
