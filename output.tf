# output "conainer-name" {
#   value       = module.container[*].container-name
#   description = "This is name of the container"
# }

# output "ip-address" {
#   value       = flatten(module.container[*].ip-address)
#   description = "The ip address for the container2."
# }

output "app_access" {
  value = [for x in module.container[*] : x]
}