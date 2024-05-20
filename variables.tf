variable "aws_region" {
  description = "For Region"
  type        = string
}


variable "db_name" {
  description = "Name of DB"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-\\_]+$", var.db_name))
    error_message = "DB Name must not be empty and can contain letters, numbers, underscores, and dashes."
  }
}

variable "db_user_name" {
  description = "RDS DB User"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_user_name) > 5
    error_message = "DB UserName must not be empty."
  }
}

variable "db_user_password" {
  description = "RDS DB User Password"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_user_password) > 8
    error_message = "DB User Password must not be empty."
  }
}
