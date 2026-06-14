output "ec2_public_ip" {
  description = "IP Publico da instancia EC2"
  value       = aws_instance.unify_ec2.public_ip
}