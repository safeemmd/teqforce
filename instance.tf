resource "aws_instance" "example" {
  ami           = var.AMI_ID
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = element(data.aws_subnet_ids.jen_subnets.id, 0)

  # the security group
  vpc_security_group_ids = [aws_security_group.jenkins_security.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
}

