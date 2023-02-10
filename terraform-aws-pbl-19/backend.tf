terraform {
   backend "s3" {
     bucket         = "micolo-dev-terraform-bucket"
     key            = "global/s3/terraform.tfstate"
     region         = "us-east-1"
     dynamodb_table = "terraform-locks"
     encrypt        = true
   }
 }

terraform {
  backend "remote" {
    organization = "zireuz"

    workspaces {
      name = "terraform-cloud"
    }
  }
}