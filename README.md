# terraform-aws-transit-gateway

Terraform module that manages an [AWS Transit
Gateway](https://aws.amazon.com/transit-gateway/). It creates a single transit
gateway with configurable route table association, propagation and DNS support,
exposing the default route table IDs for building attachments.

## Usage

```hcl
module "transit_gateway" {
  source = "github.com/cybercapybara/terraform-aws-transit-gateway"

  description     = "prod-tgw"
  amazon_side_asn = 64512

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

A runnable example lives in [`examples/basic`](examples/basic).

## Requirements

| Name      | Version  |
|-----------|----------|
| terraform | >= 1.5   |
| aws       | >= 5.0   |

## Inputs

| Name                              | Description                                             | Type          | Default                   | Required |
|-----------------------------------|---------------------------------------------------------|---------------|---------------------------|:--------:|
| `description`                     | Description of the transit gateway.                     | `string`      | `"Managed by Terraform"`  |    no    |
| `amazon_side_asn`                 | Private ASN for the Amazon side of a BGP session.       | `number`      | `64512`                   |    no    |
| `auto_accept_shared_attachments`  | Auto-accept resource attachment requests.               | `string`      | `"disable"`               |    no    |
| `default_route_table_association` | Auto-associate attachments with the default table.      | `string`      | `"enable"`                |    no    |
| `default_route_table_propagation` | Auto-propagate routes to the default table.             | `string`      | `"enable"`                |    no    |
| `dns_support`                     | Enable DNS support.                                     | `string`      | `"enable"`                |    no    |
| `vpn_ecmp_support`                | Enable ECMP support for VPN attachments.                | `string`      | `"enable"`                |    no    |
| `tags`                            | Tags applied to the transit gateway.                    | `map(string)` | `{}`                      |    no    |

## Outputs

| Name                                 | Description                                        |
|--------------------------------------|----------------------------------------------------|
| `id`                                 | ID of the transit gateway.                         |
| `arn`                                | ARN of the transit gateway.                        |
| `owner_id`                           | AWS account ID that owns the transit gateway.      |
| `association_default_route_table_id` | ID of the default association route table.         |
| `propagation_default_route_table_id` | ID of the default propagation route table.         |

## License

[MIT](LICENSE)
