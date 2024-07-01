
resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

module "image" {
  source ="./image"
  image_in = var.image[terraform.workspace]
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
# name = "nodered-prod-xkpo"
# image = module.image.image_out
# }

resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", terraform.workspace, random_string.random1[count.index].result])
  image = module.image.image_out
  ports {
    internal = var.int_port
    # external = lookup(var.ext_port,terraform.workspace)[count.index]
    external = var.ext_port[terraform.workspace][count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/noderedvol"
  }
}


