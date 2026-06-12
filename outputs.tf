output "my_vm_public_ip" {
    value = aws_instance.alexandre_serverweb.public_ip
}