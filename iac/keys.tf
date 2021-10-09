resource "tls_private_key" "petclinic" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "petclinic_kp" {
  key_name   = "petclinic_key" # Create "myKey" to AWS!!
  public_key = tls_private_key.petclinic.public_key_openssh
}