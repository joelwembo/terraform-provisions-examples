locals {
  bucket_name = "YOUR_BUCKET_NAME"
  table_name  = "YOUR_TABLE_NAME"

  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["ap-southeast-1a", "ap-southeast-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}