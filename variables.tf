variable "description" {
  description = "Description of the transit gateway."
  type        = string
  default     = "Managed by Terraform"
}

variable "amazon_side_asn" {
  description = "Private ASN for the Amazon side of a BGP session."
  type        = number
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted."
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["enable", "disable"], var.auto_accept_shared_attachments)
    error_message = "auto_accept_shared_attachments must be enable or disable."
  }
}

variable "default_route_table_association" {
  description = "Whether attachments are automatically associated with the default route table."
  type        = string
  default     = "enable"
}

variable "default_route_table_propagation" {
  description = "Whether attachments automatically propagate routes to the default route table."
  type        = string
  default     = "enable"
}

variable "dns_support" {
  description = "Whether DNS support is enabled on the transit gateway."
  type        = string
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Whether Equal Cost Multipath protocol support is enabled for VPN attachments."
  type        = string
  default     = "enable"
}

variable "tags" {
  description = "Tags applied to the transit gateway."
  type        = map(string)
  default     = {}
}
