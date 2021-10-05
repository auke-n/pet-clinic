resource "aws_s3_bucket_object" "site" {
  bucket = "your_bucket_name"
  key    = "config/site.yml"
  source = "config/ansible/site.yml"

  etag = filemd5("config/ansible/site.yml")
}