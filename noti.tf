# main.tf (취약한 S3 버킷 설정)
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "prismacloud-insecure-test-bucket"

  acl    = "public-read"  # 퍼블릭 읽기 권한 — 취약점 유발
}
