# Test-only requirement: `mock_provider` needs Terraform >= 1.7. The module
# itself still supports the >= 1.5 declared in versions.tf; running the suite is
# what needs the newer CLI. Mocking keeps `terraform test` offline and
# credential-free.
mock_provider "aws" {}

run "defaults_do_not_auto_accept_shared_attachments" {
  assert {
    condition     = aws_ec2_transit_gateway.this.auto_accept_shared_attachments == "disable"
    error_message = "Cross-account attachments must not be auto-accepted by default."
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.dns_support == "enable"
    error_message = "DNS support should be enabled by default."
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.amazon_side_asn == 64512
    error_message = "Default ASN should be the private 16-bit ASN 64512."
  }
}

run "settings_are_passed_through" {
  variables {
    description                     = "segmented tgw"
    auto_accept_shared_attachments  = "enable"
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"
    vpn_ecmp_support                = "disable"
    amazon_side_asn                 = 4200000000
    tags = {
      Environment = "test"
    }
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.description == "segmented tgw"
    error_message = "description was not passed through to the transit gateway."
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.auto_accept_shared_attachments == "enable"
    error_message = "auto_accept_shared_attachments was not passed through."
  }

  assert {
    condition = (
      aws_ec2_transit_gateway.this.default_route_table_association == "disable" &&
      aws_ec2_transit_gateway.this.default_route_table_propagation == "disable"
    )
    error_message = "Default route table association/propagation were not passed through."
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.vpn_ecmp_support == "disable"
    error_message = "vpn_ecmp_support was not passed through."
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.amazon_side_asn == 4200000000
    error_message = "A valid 32-bit private ASN must be accepted."
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.tags["Environment"] == "test"
    error_message = "tags were not applied to the transit gateway."
  }
}

run "rejects_invalid_auto_accept_shared_attachments" {
  command = plan

  variables {
    auto_accept_shared_attachments = "true"
  }

  expect_failures = [var.auto_accept_shared_attachments]
}

run "rejects_invalid_default_route_table_association" {
  command = plan

  variables {
    default_route_table_association = "Enable"
  }

  expect_failures = [var.default_route_table_association]
}

run "rejects_invalid_default_route_table_propagation" {
  command = plan

  variables {
    default_route_table_propagation = "on"
  }

  expect_failures = [var.default_route_table_propagation]
}

run "rejects_invalid_dns_support" {
  command = plan

  variables {
    dns_support = "yes"
  }

  expect_failures = [var.dns_support]
}

run "rejects_invalid_vpn_ecmp_support" {
  command = plan

  variables {
    vpn_ecmp_support = "disabled"
  }

  expect_failures = [var.vpn_ecmp_support]
}

run "rejects_public_asn" {
  command = plan

  variables {
    amazon_side_asn = 7224
  }

  expect_failures = [var.amazon_side_asn]
}

run "rejects_asn_between_the_private_ranges" {
  command = plan

  variables {
    amazon_side_asn = 65535
  }

  expect_failures = [var.amazon_side_asn]
}

run "rejects_asn_just_below_the_32bit_range" {
  command = plan

  variables {
    amazon_side_asn = 4199999999
  }

  expect_failures = [var.amazon_side_asn]
}

run "rejects_non_integer_asn" {
  command = plan

  variables {
    amazon_side_asn = 64512.5
  }

  expect_failures = [var.amazon_side_asn]
}

run "accepts_asn_upper_16bit_boundary" {
  command = plan

  variables {
    amazon_side_asn = 65534
  }
}

run "accepts_asn_upper_32bit_boundary" {
  command = plan

  variables {
    amazon_side_asn = 4294967294
  }
}

run "updates_mutable_settings_in_place" {
  # Runs against the state left behind by "settings_are_passed_through" above.
  # amazon_side_asn is left untouched here on purpose: it forces replacement
  # of the transit gateway, so changing it would not exercise an in-place
  # update. This run only flips attributes that AWS allows to be modified on
  # an existing transit gateway, and confirms the module applies that change
  # cleanly rather than erroring or silently ignoring it.
  variables {
    description                     = "segmented tgw"
    auto_accept_shared_attachments  = "disable"
    default_route_table_association = "enable"
    default_route_table_propagation = "enable"
    vpn_ecmp_support                = "enable"
    amazon_side_asn                 = 4200000000
    tags = {
      Environment = "test"
    }
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.auto_accept_shared_attachments == "disable"
    error_message = "auto_accept_shared_attachments was not updated in place."
  }

  assert {
    condition = (
      aws_ec2_transit_gateway.this.default_route_table_association == "enable" &&
      aws_ec2_transit_gateway.this.default_route_table_propagation == "enable"
    )
    error_message = "default route table association/propagation were not updated in place."
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.vpn_ecmp_support == "enable"
    error_message = "vpn_ecmp_support was not updated in place."
  }
}
