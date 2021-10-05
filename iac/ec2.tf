resource "aws_instance" "root-server" {
  ami                         = "ami-07df274a488ca9195"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_build.id
  key_name                    = "petclinic"
  vpc_security_group_ids      = [aws_security_group.root-server-sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name
  user_data                   = templatefile("config/user_data_root_server.sh", { host_name = "root-server" })

  tags = {
    Name = "root-server"
  }
  lifecycle {
    ignore_changes = [public_ip, public_dns]
  }
}

resource "aws_instance" "build-server" {
  ami                         = "ami-07df274a488ca9195"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_build.id
  key_name                    = "petclinic"
  vpc_security_group_ids      = [aws_security_group.build-server-sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name
  user_data                   = templatefile("config/user_data_build.sh", { host_name = "build-server" })

  tags = {
    Name = "build-server"
  }
  lifecycle {
    ignore_changes = [public_ip, public_dns]
  }
}

resource "aws_instance" "web-server" {
  ami                         = "ami-07df274a488ca9195"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_web.id
  key_name                    = "petclinic"
  vpc_security_group_ids      = [aws_security_group.web-server-sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name
  user_data                   = templatefile("config/user_data_web.sh", { host_name = "web-server" })


  tags = {
    Name = "web-server"
  }
  lifecycle {
    ignore_changes = [public_ip, public_dns]
  }
}

resource "aws_instance" "test-server" {
  ami                         = "ami-07df274a488ca9195"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_web.id
  key_name                    = "petclinic"
  vpc_security_group_ids      = [aws_security_group.web-server-sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name
  user_data                   = templatefile("config/user_data_test.sh", { host_name = "test-server" })


  tags = {
    Name = "web-server"
  }
  lifecycle {
    ignore_changes = [public_ip, public_dns]
  }
}
