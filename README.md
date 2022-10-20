Terraform Module to provision an EC2 Instance that is running Apache.
Only for learning purposes and not intended for Production use

```hcl
/*terraform {
  backend "remote" {
    organization = "terracert"

    workspaces {
      name = "provisioners"
    }
  }

  required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "4.31.0"
    }
  }
}*/

data "template_file" "user_data" {
    template = file("./userdata.yaml")
}

data "template_file" "private_key" {
    template = file("./id_rsa")
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJj8r0zTpqP4oV6yPHAOkIpJqZ+5YWk211vbqISV+1bao5sBvLtwDpoNV1KVD8MaxaoxEBrQ+ziXIsCXY9+toVnkv4ts3RlZji4rHou76AJFGRqna8qqkFjPhAPPbqHfECCO+FTBKc9X9iSYTScuav1xjZuCVSJI3J3izAKSZ+/RaSerULaaXxaTIS+xq45AXloJmj0XSG2w3sC88sjlsxV8L65STMYj01hp1hIshSgH99mjX1LoRmPk6yufcQRXBwPPiBPRIUFjmzG80HuxFP2hO3HzVpyZ6gZmlQwSxZYVKdMoxiLgWSgiQdt/5yf0n1RnqiuNzWftj3E/wwh87iXB/2G9D4DspuIGH5bB+CJ4CcxCWsQ/FZyJGpsNtB95VS3FAzeO7usT6Qa6SgxDapVGWRttrCzL2QZ9wwL/9VopocmXMJiGUCFJKxGrbLmKlVok7HoGJ+ihwSvATK7PJ9AP7FMzsyJ1vrdoudve4eYDSfIsmE/79n+tnWdjMBXkk= ubuntu@ip-172-31-47-41"
}

resource "aws_instance" "terratest" {
#    ami           = "ami-06489866022e12a14"
#    instance_type = "t2.micro"
    ami = var.ami_id
    instance_type = var.instance_type     
    key_name = "${aws_key_pair.deployer.key_name}"
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    user_data = data.template_file.user_data.rendered

    tags = {
        Name = "TerraServer"
        Region = "ap-south-1"
        Project = "2022-provisioners"
        Target = "Time-EC2"
        Tier = "Free"
        Userdata = "Yes"
    }

    provisioner "file" {
      content = "Instance AMI: ${self.ami}"
      destination = "/home/ec2-user/ami-info.txt"
      connection {
        type     = "ssh"
        user     = "ec2-user"
        host     = "${self.public_ip}"
#       private_key = data.template_file.private_key.filename - Follow a simpler assignment as below
        private_key = file("./id_rsa")
      }
    }
}

resource "null_resource" "status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.terratest.id}"
  }
  depends_on = [
    aws_instance.terratest
  ]

}

data "aws_vpc" "main" {
    id = "vpc-0ff2f60c97e722d6f"
}
resource "aws_security_group" "web_sg" {
  name        = "Web Server SG"
  description = "Allow HTTP & HTTPS Traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false

    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

/*  egress = {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  } */

  tags = {
    Name = "websg"
  }
}
```
