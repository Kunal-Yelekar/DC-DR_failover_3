terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-state-bucket-knl2"
    key            = "terraform/statefile"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}
