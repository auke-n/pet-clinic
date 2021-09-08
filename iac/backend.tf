terraform {
  backend "s3" {
    encrypt = true
    bucket = "petclinic-tfstate"
    region = "eu-central-1"
    key = "terraform.tfstate"
  }
}