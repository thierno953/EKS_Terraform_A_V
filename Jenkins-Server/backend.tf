terraform {
  backend "s3" {
    bucket = "cicdterraform-eks"
    key    = "jenkins/terraform.tfstate"
    region = "eu-west-3"
  }
}