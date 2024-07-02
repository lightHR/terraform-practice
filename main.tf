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

module "container" {
  source = "./container"
  count = local.container_count
  name_in  = join("-", ["nodered", terraform.workspace, random_string.random1[count.index].result])
  image_in = module.image.image_out
  int_port_in = var.int_port
  # external = lookup(var.ext_port,terraform.workspace)[count.index]
  ext_port_in = var.ext_port[terraform.workspace][count.index]
  container_path_in = "/data"
  host_path_in      = "${path.cwd}/noderedvol"
}



