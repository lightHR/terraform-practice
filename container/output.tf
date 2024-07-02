output "container-name" {
  value       = docker_container.nodered_container.name
  description = "This is name of the container"
}

output "ip-address" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.network_data[0].ip_address, i.ports[0].external])]
  description = "The ip address for the container2."
}

