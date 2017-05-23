#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>#
variable "env" {
  description = "Environment (dev,qa,prod)"
  default     = "dev"
}

variable "access_key" {
  description = "AWS access key"
  default     = ""
}

variable "secret_key" {
  description = "AWS secret access key"
  default     = ""
}

variable "region" {
  description = "AWS region to host the environment"
  default     = "us-west-2"
}

#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>#

