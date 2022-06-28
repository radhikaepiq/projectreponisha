provider "aws" {
  region = "ap-south-1"
  # access_key = "AKIA2MVKBF73IN4UORPM"
  # secret_key = "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"
}
#  vpc creation 
resource "aws_vpc" "vpc_nisha" {
cidr_block = "172.30.12.0/24"
  tags = {
    Name = "Nisha_vpc"
    Owner = "Nisha"
    Purpose = "devops_project "
  }
}

# # CREATE PUBLIC SUBNET  
resource "aws_subnet" "public_subnet" {
vpc_id = aws_vpc.vpc_nisha.id
cidr_block ="172.30.12.0/25"
map_public_ip_on_launch ="true"
availability_zone = "ap-south-1a"
tags = {
    Name = "Nisha"
    Owner = "NishaSalunke"
    Purpose = "devops_project "
}
}
# # CREATE Private SUBNET 
 resource "aws_subnet" "private_subnet" {
 vpc_id = aws_vpc.vpc_nisha.id
 cidr_block ="172.30.12.128/25"
 map_public_ip_on_launch ="false"
 availability_zone = "ap-south-1a"
 tags = {
     Name = "Nisha"
    Owner = "Nisha"
    Purpose = "devops_project "
 }
 }

# /////IGW///////////////////
resource "aws_internet_gateway" "Nisha_IG" {
  vpc_id = aws_vpc.vpc_nisha.id
    tags = {
    Name = "Nisha"
    Owner = "NishaSalunke"
    Purpose = "devops_project "
  }
}

# /////////////Custom route tabel and attache it to public subnet/////
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc_nisha.id
  tags = {
    Name ="Nisha"
    Owner = "Nisha"
    Purpose = "devops_project "
  }
}

resource "aws_route_table_association" "Associatepublicroute" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}
resource "aws_route" "route_public" {
  route_table_id = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Nisha_IG.id
}

# /////////////Custom route tabel and attach it to private subnet/////
 resource "aws_route_table" "private_route" {
   vpc_id = aws_vpc.vpc_nisha.id
   tags = {
    Name ="Nisha"
    Owner = "Nisha"
    Purpose = "devops_project "
   }
 }

 resource "aws_route_table_association" "Associateprivateroute" {
   subnet_id      = aws_subnet.private_subnet.id
   route_table_id = aws_route_table.private_route.id
 }


#########security group#########
resource "aws_security_group" "Nisha-SG" {
  vpc_id      = aws_vpc.vpc_nisha.id
  name = "Nisha-SG"
 
  #Incoming traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
# #Public subnet and instance 2
resource "aws_spot_instance_request" "nisha_spotinstance1" {

  ami = "ami-079b5e5b3971bd10d"
  spot_price             = "0.03"
  instance_type          = "t2.micro"
  spot_type              = "one-time"
  wait_for_fulfillment   = "true"
  subnet_id = aws_subnet.public_subnet.id
  key_name               = "nishasalunkekey"
  security_groups = [aws_security_group.Nisha-SG.id]
}

# #Private subnet and instance 2

 resource "aws_spot_instance_request" "nisha_spotinstance2" {
 ami = "ami-079b5e5b3971bd10d"
 spot_price             = "0.03"
 instance_type          = "t2.micro"
 spot_type              = "one-time"
 wait_for_fulfillment   = "true"
 subnet_id = aws_subnet.private_subnet.id
 key_name               = "nishasalunkekey"
 security_groups = [aws_security_group.Nisha-SG.id]
 }

  output "public_instance_ip" {
    value = aws_spot_instance_request.nisha_spotinstance1.public_ip
    
  }
  output "private_instance_ip" {
 value = aws_spot_instance_request.nisha_spotinstance2.private_ip
  }
 
 ///s3 bucket creation with version control
# resource "aws_s3_bucket" "salunkens21_bucket" {
#   bucket = "salunkens21-bucket"
# }

# resource "aws_s3_bucket_acl" "salunken21" {
#   bucket = aws_s3_bucket.salunkens21_bucket.id
#   acl    = "public-read"
# }

# resource "aws_s3_bucket_versioning" "versioning_salunkens21" {
#   bucket = aws_s3_bucket.salunkens21_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

