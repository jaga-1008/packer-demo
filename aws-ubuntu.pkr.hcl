packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "jaga-packer-apache2-linux-aws"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.0.20210326.0-x86_64-gp2-nodejs14"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["782511650046"]
  }
  ssh_username = "ec2-user"
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    destination = "~/"
    source      = "./index.html"
  }

  provisioner "shell" {
    inline = [
      "echo Installing Apache",
      "sudo yum update",
      "sudo yum install -y httpd",
      "sudo cp ~/index.html /var/www/html/",
      "sudo systemctl start httpd"
    ]
  }
}
