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
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
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
      "sudo yum install -y apache2",
      "sudo cp ~/index.html /var/www/html/",
      "sudo systemctl start apache2"
    ]
  }
}
