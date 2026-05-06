terraform {
  backend "s3" {
    bucket = "noor-terraform-state-ap-south1"
    key="week-3/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    
  }
}