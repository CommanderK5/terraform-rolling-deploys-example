## Terrafomr Rolling Deploys Example

This is an example of how to achieve rolling deploys on AWS using Terraform. It is based on a strategy proposed by Paul Hinze - https://groups.google.com/forum/#!msg/terraform-tool/7Gdhv1OAc80/iNQ93riiLwAJ

## Setup

```
terraform apply
```

browes to ```rolling_ELB_dns_name```

## Rolling update
```
terraform apply -var 'ami_id=ami-1234'
```

## Note

Tested on Terraform 0.7.11

## License

MIT License
