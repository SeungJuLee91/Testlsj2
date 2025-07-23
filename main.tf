provider "aws" {
  region = "ap-northeast-1" # 도쿄 리전으로 설정
}

resource "aws_instance" "my_instance" {
  ami           = "ami-09d8ed8255877048d"
  instance_type = "t3.micro"

  metadata_options {
    http_endpoint = "enabled"  # 메타데이터 서비스 사용 
    http_tokens   = "required" # IMDSv2만 허용
  }

  tags = {
    Name = "TerraformTest"
  }
}
