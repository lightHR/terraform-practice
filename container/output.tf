# output "container-name" {
#   value       = docker_container.nodered_container.name
#   description = "This is name of the container"
# }

# output "ip-address" {
#   value       = [for i in docker_container.nodered_container[*] : join(":", [i.network_data[0].ip_address, i.ports[0].external])]
#   description = "The ip address for the container2."
# }


output "application_access" {
    value = {for x in docker_container.app_container[*]: x.name => join(":",x.network_data[*].ip_address, x.ports[*]["external"])}
}