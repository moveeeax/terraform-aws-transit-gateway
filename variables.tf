variable "description" {
  description = "Description of the transit gateway."
  type        = string
  default     = "Managed by Terraform"
}

variable "amazon_side_asn" {
  description = "Private ASN for the Amazon side of a BGP session. Must be in the 16-bit private range 64512-65534 or the 32-bit private range 4200000000-4294967294."
  type        = number
  default     = 64512

  validation {
    condition = (
      (var.amazon_side_asn >= 64512 && var.amazon_side_asn <= 65534) ||
      (var.amazon_side_asn >= 4200000000 && var.amazon_side_asn <= 4294967294)
    )
    error_message = "amazon_side_asn must be between 64512 and 65534 (16-bit) or between 4200000000 and 4294967294 (32-bit)."
  }
}

variable "auto_accept_shared_attachments" {
  description = "Whether attachment requests from other accounts are accepted automatically. Keep this disabled unless every account the gateway is shared with is trusted: an auto-accepted attachment joins the gateway with no review step."
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

  validation {
    condition     = contains(["enable", "disable"], var.default_route_table_association)
    error_message = "default_route_table_association must be enable or disable."
  }
}

variable "default_route_table_propagation" {
  description = "Whether attachments automatically propagate routes to the default route table."
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["enable", "disable"], var.default_route_table_propagation)
    error_message = "default_route_table_propagation must be enable or disable."
  }
}

variable "dns_support" {
  description = "Whether DNS support is enabled on the transit gateway."
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["enable", "disable"], var.dns_support)
    error_message = "dns_support must be enable or disable."
  }
}

variable "vpn_ecmp_support" {
  description = "Whether Equal Cost Multipath protocol support is enabled for VPN attachments."
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["enable", "disable"], var.vpn_ecmp_support)
    error_message = "vpn_ecmp_support must be enable or disable."
  }
}

variable "tags" {
  description = "Tags applied to the transit gateway."
  type        = map(string)
  default     = {}
}
