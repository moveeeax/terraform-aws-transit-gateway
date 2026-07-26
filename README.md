# terraform-aws-transit-gateway

Terraform module that manages an [AWS Transit
Gateway](https://aws.amazon.com/transit-gateway/). It creates a single transit
gateway with configurable route table association, propagation and DNS support,
exposing the default route table IDs for building attachments.

## Usage

```hcl
module "transit_gateway" {
  source = "github.com/moveeeax/terraform-aws-transit-gateway"

  description     = "prod-tgw"
  amazon_side_asn = 64512

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

A runnable example lives in [`examples/basic`](examples/basic).

## Sharing the gateway across accounts

The module does not create a RAM resource share; sharing is left to the caller so
the principals stay explicit. Two defaults matter when you do share the gateway:

- `auto_accept_shared_attachments` defaults to `"disable"`. Enabling it means any
  attachment request from a principal the gateway is shared with joins the
  gateway with no review step, so enable it only when every one of those
  principals is trusted.
- `default_route_table_association` and `default_route_table_propagation` default
  to `"enable"`, matching the AWS default: every attachment lands in one flat
  routing domain that reaches every other attachment. For a segmented gateway set
  both to `"disable"` and manage `aws_ec2_transit_gateway_route_table`
  associations and propagations explicitly.

Enabling auto-accept while both defaults are left on is the combination worth
avoiding: a shared account can attach a VPC and reach every other attachment
without anyone approving it.

## Requirements

| Name      | Version  |
|-----------|----------|
| terraform | >= 1.5   |
| aws       | >= 5.0   |

## Inputs

| Name                              | Description                                             | Type          | Default                   | Required |
|-----------------------------------|---------------------------------------------------------|---------------|---------------------------|:--------:|
| `description`                     | Description of the transit gateway.                     | `string`      | `"Managed by Terraform"`  |    no    |
| `amazon_side_asn`                 | Private ASN for the Amazon side of a BGP session. Must be a whole number, 64512-65534 or 4200000000-4294967294. | `number` | `64512` |    no    |
| `auto_accept_shared_attachments`  | Auto-accept cross-account attachment requests. `enable` \| `disable`. | `string` | `"disable"`  |    no    |
| `default_route_table_association` | Auto-associate attachments with the default table. `enable` \| `disable`. | `string` | `"enable"` |    no    |
| `default_route_table_propagation` | Auto-propagate routes to the default table. `enable` \| `disable`. | `string` | `"enable"`       |    no    |
| `dns_support`                     | Enable DNS support. `enable` \| `disable`.              | `string`      | `"enable"`                |    no    |
| `vpn_ecmp_support`                | Enable ECMP support for VPN attachments. `enable` \| `disable`. | `string` | `"enable"`         |    no    |
| `tags`                            | Tags applied to the transit gateway.                    | `map(string)` | `{}`                      |    no    |

Every `enable`/`disable` input is validated, so a typo such as `"Enable"` or
`"true"` fails at plan time instead of surfacing as an AWS API error mid-apply.

## Outputs

| Name                                 | Description                                        |
|--------------------------------------|----------------------------------------------------|
| `id`                                 | ID of the transit gateway.                         |
| `arn`                                | ARN of the transit gateway.                        |
| `owner_id`                           | AWS account ID that owns the transit gateway.      |
| `association_default_route_table_id` | ID of the default association route table.         |
| `propagation_default_route_table_id` | ID of the default propagation route table.         |

## Tests

The suite in [`tests/`](tests) uses a mocked AWS provider, so it needs no
credentials and no network:

```sh
terraform init -backend=false
terraform test
```

`terraform test` with `mock_provider` requires Terraform >= 1.7 to run; the
module itself still supports >= 1.5.

## License

[MIT](LICENSE)
