resource "aws_instance" "jenkins-server" {
  ami = "ami-07df274a488ca9195"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_build.id
  key_name = "petclinic"
  vpc_security_group_ids = [aws_security_group.jenkins-server-sg.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  user_data = file("config/user_data_jenkins.sh")

  tags = {
    Name = "jenkins-server"
  }
  lifecycle {
    ignore_changes = [public_ip, public_dns]
  }
}

resource "aws_instance" "build-server" {
  ami = "ami-07df274a488ca9195"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_build.id
  key_name = "petclinic"
  vpc_security_group_ids = [aws_security_group.build-server-sg.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
/*  user_data = file("config/user_data_build.sh")*/

  tags = {
    Name = "build-server"
  }
  lifecycle {
    ignore_changes = [public_ip, public_dns]
  }
}

resource "aws_instance" "prod-server" {
  ami = "ami-07df274a488ca9195"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_prod.id
  key_name = "petclinic"
  vpc_security_group_ids = [aws_security_group.web-server-sg.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
/*  user_data = file("config/user-data-prod.sh")*/

  tags = {
    Name = "web-server"
  }
  lifecycle {
    ignore_changes = [public_ip, public_dns]
  }
}
