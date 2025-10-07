####### Setup Terraform and AWS Regin #######

terraform {
  required_version = "=> 1.5.0"

  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

####### Get Default VPC #######

data "aws_vpc" "default" {
  default = true
}

#### S3 Bucket Setup for Security an Privacy data protecction #####

resource "aws_s3_bucket" "static_website" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key="index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_website.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsondecode({
    version="2012-10-17"
    statement= [
        {
            Sid       = "PublicReadGetObject"
            Effect    = "Allow"
            Principal = "*"
            Action    = "s3:GetObject"
            Resource  = "${aws_s3_bucket.static_site.arn}/*"
        }
    ] 
  })
}

###### Security Group for EC-2 (jenkis Server) #####
resource "aws_security_group" "jenkins_sg" {
  name = "jenkins_sg"
  description = "Allow SSH and Jenkins"
  vpc_id = data.aws_vpc.default.id

  ingress = [{
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = [  ]
    self = false
  },
  {
    description = "jenkins"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = []
    prefix_list_ids = [  ]
    security_groups = []
    self = false
  },
  {
    description = "HTTP"
    from_port = 80
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [  ]
    prefix_list_ids = [  ]
    security_groups = [  ]
    self = false
  }  ]

  egress = [
    {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [  ]
        prefix_list_ids = [  ]
        security_groups = [  ]
        self = false
    }
    ]
}

##### Jenkins Instance #####
resource "aws_instance" "static_webapp" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
    user_data = file("${path.module}/user_data.sh")

    tags = {
        name= "Jenkins_server"
    }
  
}