resource "aws_instance" "root-server" {
  ami                         = "ami-07df274a488ca9195"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_build.id
  key_name                    = aws_key_pair.petclinic_kp.key_name
  vpc_security_group_ids      = [aws_security_group.root-server-sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name
  user_data = templatefile("config/user_data_root_server.sh", {
    build_ip = aws_instance.build-server.private_ip
    test_ip  = aws_instance.test-server.private_ip
    web_ip   = aws_instance.web-server.private_ip
    prv_key  = tls_private_key.petclinic.private_key_pem
  })

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "root-server"
  }
}

resource "aws_instance" "build-server" {
  ami                    = "ami-07df274a488ca9195"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_build.id
  key_name               = aws_key_pair.petclinic_kp.key_name
  vpc_security_group_ids = [aws_security_group.build-server-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2-profile.name
  user_data              = templatefile("config/user_data_build.sh", { host_name = "build-server" })

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "build-server"
  }
}

resource "aws_instance" "test-server" {
  ami                    = "ami-07df274a488ca9195"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_web.id
  key_name               = aws_key_pair.petclinic_kp.key_name
  vpc_security_group_ids = [aws_security_group.web-server-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2-profile.name
  user_data              = templatefile("config/user_data_test.sh", { host_name = "test-server" })

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "test-server"
  }
}

resource "aws_instance" "web-server" {
  ami                         = "ami-07df274a488ca9195"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_web.id
  key_name                    = aws_key_pair.petclinic_kp.key_name
  vpc_security_group_ids      = [aws_security_group.web-server-sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name
  user_data                   = templatefile("config/user_data_web.sh", { host_name = "web-server" })

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "web-server"
  }
}


