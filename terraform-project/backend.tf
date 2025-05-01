terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-state-bucket-knl2"
    key            = var.remote_state_key
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}
