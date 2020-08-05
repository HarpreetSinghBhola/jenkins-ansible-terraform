terraform {

  backend "s3" {
    profile = "default"
    region  = "us-east-1"
    bucket          = "tfstate-bucket-har"
    key     = "terraform.tfstate"
  }
}
