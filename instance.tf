resource "aws_instance" "jenkins_instance" {
  ami           = var.AMI_ID
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = element(tolist(data.aws_subnet_ids.jen_subnets.ids), 0)

  # the security group
  vpc_security_group_ids = [aws_security_group.jenkins_security.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  user_data = "${file("scripts/userdata-new.sh")}"

  tags = {
    Name = "Jenkins"
  }
}

