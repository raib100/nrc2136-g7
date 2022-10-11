# Output for the public DNS of the EC2 instance
output "ec2_dns" {
  value = aws_instance.api_instance.public_dns
}