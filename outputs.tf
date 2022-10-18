output "private_ip" {
    value = <<EOT
        %{ for ip in aws_instance.terratest.*.private_ip }
        server ${ip}
        %{ endfor }
        EOT
}