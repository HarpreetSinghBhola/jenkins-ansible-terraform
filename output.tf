output "Public_Endpoint" {
  value = "${aws_instance.web.public_dns}"
}
