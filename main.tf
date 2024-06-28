terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

variable ext_port{
  type=number
  default=1880
}

variable int_port{
  type=number
  default=1880
}

variable container_count {
  type = number
  default=1
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random1"{
  count = var.container_count
  length = 4
  special = false
  upper = false
  numeric = false
}


resource "docker_container" "nodered_container" {
  count = var.container_count
  name  = join("-",["nodered",random_string.random1[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = var.int_port
    external = var.ext_port
  }
}


output "conainer-name" {
  value = docker_container.nodered_container[*].name
  description = "This is name of the container"
}

output "ip-address" {
  value = [for i in docker_container.nodered_container[*]: join(":", [i.network_data[0].ip_address,i.name])]
  description = "The ip address for the container2."
}

