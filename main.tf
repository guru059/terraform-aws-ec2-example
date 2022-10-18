terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "4.31.0"
    }
  }
}

provider "aws" {
    profile = "default"
    region  = "ap-south-1"
    alias = "apsouth"
}

provider "aws" {
    profile = "default"
    region  = "us-west-1"
    alias = "uswest"
}

data "aws_ami" "amz-linux-2" {
    most_recent = true
    owners = ["amazon"]
    filter {
      name = "owner-alias"
      values = ["amazon"]
    }
    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }
}

resource "aws_instance" "terratest" {
    ami           = data.aws_ami.amz-linux-2.id
    instance_type = "t2.micro"
    provider = aws.apsouth
    tags = {
        Name = "TerraServer AP South"
#        Region = "%{ if var.region == "apsouth"}${var.region}%{ else }${"Please set the correct region"}%{ endif }"
        Region = "%{ if var.region == "apsouth"}${var.region}%{ endif }"
    }
}