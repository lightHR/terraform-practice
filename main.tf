terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

resource "docker_image" "nodered_image" {
  name = lookup(var.image,terraform.workspace)
}

resource "random_string" "random1" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
  numeric = false
}

# resource "docker_container" "nodered_container1" {
# name = "nodered-zydb"
# image = docker_image.nodered_image.image_id 
# }

# resource "docker_container" "nodered_container2" {
# name = "nodered-kgom"
# image = docker_image.nodered_image.image_id 
# }

resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", terraform.workspace, random_string.random1[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = var.int_port
    external = lookup(var.ext_port,terraform.workspace)[count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/noderedvol"
  }
}


