
module "image" {
  source   = "./image"
  for_each = local.deployment
  image_in = each.value.image
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
  source            = "./container"
  count_in          = each.value.container_count
  for_each          = local.deployment
  name_in           = each.key
  image_in          = module.image[each.key].image_out
  int_port_in       = each.value.int
  ext_port_in       = each.value.ext
  volumes_in         = each.value.volumes
}



