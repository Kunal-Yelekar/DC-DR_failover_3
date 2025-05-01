terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-state-bucket-knl2"
    key            = "terraform/state.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks" # Enables state locking
  }
}
