variable "env" {
  type    = string
  default = "dev"
}

variable "image" {
  type        = map(any)
  description = "impage for container"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = list(number)

  validation {
    condition     = max(var.ext_port...) <= 65535 && min(var.ext_port...) > 0
    error_message = "The external port must be in the valid port range 0 - 65535."
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
  container_count = length(var.ext_port)
}

