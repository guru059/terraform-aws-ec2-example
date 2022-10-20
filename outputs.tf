output "public_ip" {
  value = aws_instance.terratest.public_ip
}                                                

output "instance_type" {
  value = aws_instance.terratest.instance_type
  # Output of a sensitive variable should also be marked as sensitive. Else it will error out
  # However, the vice versa need not be the case i.e, non sensitive var can be marked as sensitive in the output
  sensitive = true
}
