# Variable - Default Value
variable "instance_type" {
  type = string
  default = "t2.micro" 
  sensitive = true
  validation {
    condition     = length(var.instance_type) > 4 && substr(var.instance_type, 3, 7) == "micro"
    error_message = "Only t2.micro is allowed in Free Tier. Please check"
  }
}

# Variable - User Input
variable "ami_id" {
  type = string
  default = "ami-06489866022e12a14"
  validation {
    condition     = substr(var.ami_id, 0, 4) == "ami-"
    error_message = "Image Name is incorrectly specified. Please check"
  }
}
