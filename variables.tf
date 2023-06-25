variable "region" {
  description = "choice of region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "choice of instance_type"
  type        = string
  default     = "t2.micro"
}

variable "availability_zone" {
  description = "choice of availability_zone"
  type        = string
  default     = "us-east-1d"
}