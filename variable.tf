variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"

}

variable "vpc_cidr" {
  description = "vpc cidr"
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "project name"
  default     = "Three-tier"
}

variable "private_app_1_cidr" {
  description = "aws private subnet 1"
  default     = "10.0.11.0/24"

}

variable "private_app_2_cidr" {
  description = "aws private subnet 2"
  default     = "10.0.12.0/24"


}

variable "private_db_1_cidr" {
  description = "aws db 1"
  default     = "10.0.21.0/24"

}

variable "private_db_2_cidr" {
  description = "aws db 2"
  default     = "10.0.22.0/24"

}

 