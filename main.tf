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
  count = 1
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
  count = 1
  name  = join("-",["nodered",random_string.random1[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = 1880
    //external = 1880
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

