# Create all security groups dynamically
resource "aws_security_groups" "ACS" {
    for_each = local.security_groups
    name = each.value.Name
    description = each.value.description
    vpc_id = var.vpc.id
dynamic "ingress" {
    for_each = each.value.ingress
    content {
    from_port = ingress.value.from
    to_port = ingress.value.to
    protocol = ingress.value.protocol
    cidr_blocks = ingress.value.cidr_blocks
}
}
egress {
    from_port = 0
    to_port = 0
    protocol = ".1"
    cidr_blocks = ["0.0.0.0/0"]
}

tags = merge(
    var.tags,
    {
        Name = each.value.name
    },
  )
}
