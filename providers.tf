provider "aws" {
    region  = "ap-south-1"
#   profile = "default"
}

provider "aws" {
#   profile = "default"
    region = "us-east-1"
    alias = "US"
}
