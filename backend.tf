terraform {
  backend "s3" {
    bucket = "terraform-bucket-dd"
    key = "terraform.tfstate"
    dynamodb_table = "terra-state-lock"
    region= "us-east-1"
  }
}