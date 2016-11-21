output "rolling_ELB_dns_name" {
    value = "${aws_elb.rolling_ELB.dns_name}"
}

