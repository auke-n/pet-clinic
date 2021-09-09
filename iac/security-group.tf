resource "aws_security_group" "jenkins-server-sg" {
  name = "jenkins-server-sg"
  vpc_id = aws_vpc.petclinic.id

  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    security_groups = [aws_security_group.jenkins-elb-sg.id]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sever-sg"
  }
}

resource "aws_security_group" "jenkins-elb-sg" {
  name = "jenkins-elb-sg"
  vpc_id = aws_vpc.petclinic.id
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-elb-sg"
  }
}

resource "aws_security_group" "web-server-sg" {
  name = "web-server-sg"
  vpc_id = aws_vpc.petclinic.id
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = [aws_security_group.web-elb-sg.id]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [aws_security_group.jenkins-server-sg.id]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

resource "aws_security_group" "web-elb-sg" {
  name = "web-elb-sg"
  vpc_id = aws_vpc.petclinic.id
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-elb-sg"
  }
}

resource "aws_security_group" "build-server-sg" {
  name = "build-server-sg"
  vpc_id = aws_vpc.petclinic.id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [aws_security_group.jenkins-server-sg.id]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "build-server-sg"
  }
}