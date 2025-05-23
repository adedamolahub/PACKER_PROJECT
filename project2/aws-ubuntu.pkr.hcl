packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws-2"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami = "ami-084568db4383264d4"
#   source_ami_filter {
#     filters = {
#       name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
#       root-device-type    = "ebs"
#       virtualization-type = "hvm"
#     }
#     most_recent = true
#     owners      = ["904233118048"]
#   }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]


    provisioner "shell" {
    # environment_vars = [
    #     "FOO=hello world",
    # ]
    inline = [
        "sudo apt-get update -y",
        "sudo apt-get install -y nginx",
        "sudo systemctl enable nginx",
        "sudo systemctl start nginx",
        "sudo ufw allow 22",
        "sudo ufw allow 80",
        
    ]
    }

    post-processor "manifest" {
    output = "./project2/builds/manifest.json"
  }
}
