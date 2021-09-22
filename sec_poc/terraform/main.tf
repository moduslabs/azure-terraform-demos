# This is a security test
# Never expose your access_key or secret_key
provider "aws" {
access_key = "AKIAWNQSRZEWIFM3OYIN"
secret_key = "8jX5Ti1yzv92RWvERjtQ0O2Bwv3yLPv/CmazWozJ"
region     = "us-east-1"
}

resource "aws_s3_bucket" "bucket-demo" {
  bucket = "fms-bucket-demo-259624"
  acl    = "private"
}