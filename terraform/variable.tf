variable "aws_region" {
  description = "AWS Region to setup Server"
  type = string
  default = "ua-east-1"
}

variable "s3_bucket_name" {
  description = "S3 BucketUnique Name"
  type = string
  default = "static_website_s3_bucket"
}

variable "ami_id" {
  description = "Ubuntu Image ID"
  type = string
  default = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS (us-east-1)"
}

variable "instance_type" {
  description = "Define EC-2 instance type"
  type = string
  default = "t2.micro"
}

variable "key_name" {
  description = "EC-2 Instance Security key"
  type = string
  default = "key"
}