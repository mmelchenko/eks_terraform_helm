variable "region" {
  default = "eu-north-1"
}

variable "cluster_name" {
  default = "devops-cluster"
}

variable "cluster_version" {
  default = "1.27"
}

variable "node_instance_type" {
  default = "t3.micro"
}

variable "desired_capacity" {
  default = 2
}

variable "min_capacity" {
  default = 1
}

variable "max_capacity" {
  default = 3
}
