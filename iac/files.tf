resource "aws_s3_bucket_object" "ans_inv" {
  bucket  = "petclinic01"
  key     = "config/ansible/hosts"
  source = "config/ansible/hosts"
  etag = filemd5("config/ansible/hosts")
}






/*
resource "aws_s3_bucket_object" "ans_inv" {
  bucket  = "petclinic01"
  key     = "config/ansible/hosts"
  content = templatefile("config/ansible/hosts", {
    build_server = aws_instance.build-server.private_ip
    test_server  = aws_instance.test-server.private_ip
    web_server   = aws_instance.web-server.private_ip
  })
}*/
