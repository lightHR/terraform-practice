terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random1"{
  count = 2
  length = 4
  special = false
  upper = false
  numeric = false
}

# resource "random_string" "random2" {
#   length = 4
#   special = false
#   upper = false
#   numeric = false
# }


resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-",["nodered",random_string.random1[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = 1880
    //external = 1880
  }
}

# resource "docker_container" "nodered_container2" {
#   name  = join("-",["nodered2", random_string.random2.result])
#   image = docker_image.nodered_image.image_id
#   ports {
#     internal = 1880
#     //external = 1880
#   }
# }

output "ip-address" {
  value = join(":", [docker_container.nodered_container[0].network_data[0].ip_address],[docker_container.nodered_container[0].ports[0].external])
  description = "The ip address for the container."
}

output "conainer-name" {
  value = docker_container.nodered_container[0].name
  description = "This is name of the container"
}

output "ip-address2" {
  value = join(":", [docker_container.nodered_container[1].network_data[0].ip_address],[docker_container.nodered_container[1].ports[0].external])
  description = "The ip address for the container2."
}

output "conainer-name2" {
  value = docker_container.nodered_container[1].name
  description = "This is name of the container"
}