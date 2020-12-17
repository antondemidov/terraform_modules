output "subnet_ids" {
  value = join(",", aws_subnet.public.*.id)
}

output "subnet_by_azs" {
  value = zipmap(aws_subnet.public.*.availability_zone, aws_subnet.public.*.id)
}

output "route_table_ids" {
  value = join(",", aws_route_table.public.*.id)
}
