variable "image" {
  type        = map(any)
  description = "impage for container"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = map

  validation {
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
    error_message = "The external port must be in the valid port range 1980 - 65535."
  }
  
   validation {
    condition     = max(var.ext_port["prod"]...) <= 1980 && min(var.ext_port["prod"]...) >= 1880
    error_message = "The external port must be in the valid port range 1880- 1980."
  }
}

variable "int_port" {
  type    = number
  default = 1880

  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

# errored - function connot applied in variable so replacing this with locals
# variable container_count {
#   type = number
#   default= length(var.ext_port)
# }

locals {
  container_count = length(lookup(var.ext_port,terraform.workspace))
}

