# vpc.tf
# Create VPC/Subnet/Security Group/Network ACL
provider "aws" {
  version = "~> 2.0"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
  region     = var.region
}
# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = var.vpcName
}
} # end resource
# create the Subnets
resource "aws_subnet" "ZoneA_Public_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.publicsubnetzoneACIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneA
tags = {
   Name = "ZoneA_Public_Subnet"
}
} # end resource

resource "aws_subnet" "ZoneA_Private_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.privatesubnetzoneACIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneA
tags = {
   Name = "ZoneA_Private_Subnet"
}
}
resource "aws_subnet" "ZoneB_Public_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.publicsubnetzoneBCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneB
tags = {
   Name = "ZoneB_Public_Subnet"
}
}
resource "aws_subnet" "ZoneB_Private_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.privatesubnetzoneBCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneB
tags = {
   Name = "ZoneB_Priavte_Subnet"
}
}
# Create the Security Group
resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id       = aws_vpc.My_VPC.id
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "My VPC Security Group"
   Description = "My VPC Security Group"
}
} # end resource
#Create EIPs for NAT Gateways
resource "aws_eip" "NATzoneAEIP" {
  vpc = true
}

resource "aws_eip" "NATzoneBEIP" {
  vpc = true
}
#Create NAT Gateway
resource "aws_nat_gateway" "gwzoneA" {
  allocation_id = aws_eip.NATzoneAEIP.id
  subnet_id     = aws_subnet.ZoneA_Public_Subnet.id
  tags = {
    Name = "gw NAT"
  }
}
resource "aws_nat_gateway" "gwzoneB" {
  allocation_id = aws_eip.NATzoneBEIP.id
  subnet_id     = aws_subnet.ZoneB_Public_Subnet.id
  tags = {
    Name = "gw NAT"
  }
}
# Create the Internet Gateway
resource "aws_internet_gateway" "VPC_GW" {
 vpc_id = aws_vpc.My_VPC.id
 tags = {
        Name = "My VPC Internet Gateway"
}
} # end resource
# Create the Route Table
resource "aws_route_table" "Public_route_table" {
 vpc_id = aws_vpc.My_VPC.id
 tags = {
        Name = "Public_route_table"
}
} # end resource
# Create the Internet Access
resource "aws_route" "Public_Route_internet_access" {
  route_table_id         = aws_route_table.Public_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.VPC_GW.id
} # end resource
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "Gateway_VPC_association_ZoneA" {
  subnet_id      = aws_subnet.ZoneA_Public_Subnet.id
  route_table_id = aws_route_table.Public_route_table.id
}
resource "aws_route_table_association" "Gateway_VPC_association_ZoneB" {
  subnet_id      = aws_subnet.ZoneB_Public_Subnet.id
  route_table_id = aws_route_table.Public_route_table.id
}
# end resource
# Create the Route Table
resource "aws_route_table" "Private_route_table_ZoneA" {
 vpc_id = aws_vpc.My_VPC.id
 tags = {
        Name = "Private_route_table_ZoneA"
}
}
# Create the Internet Access
resource "aws_route" "Private_Route_ZoneA_access" {
  route_table_id         = aws_route_table.Private_route_table_ZoneA.id
  destination_cidr_block = var.destinationCIDRblock
  nat_gateway_id         = aws_nat_gateway.gwzoneA.id
} # end resource
resource "aws_route_table" "Private_route_table_ZoneB" {
 vpc_id = aws_vpc.My_VPC.id
 tags = {
        Name = "Private_route_table_ZoneB"
}
}
resource "aws_route" "Private_Route_ZoneB_access" {
  route_table_id         = aws_route_table.Private_route_table_ZoneB.id
  destination_cidr_block = var.destinationCIDRblock
  nat_gateway_id         = aws_nat_gateway.gwzoneB.id
} # end resource

resource "aws_route_table_association" "NATGateway_Subnet_association_ZoneA" {
  subnet_id      = aws_subnet.ZoneA_Private_Subnet.id
  route_table_id = aws_route_table.Private_route_table_ZoneA.id
}
resource "aws_route_table_association" "NATGateway_Subnet_association_ZoneB" {
  subnet_id      = aws_subnet.ZoneB_Private_Subnet.id
  route_table_id = aws_route_table.Private_route_table_ZoneB.id
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "harpreet"
  subnet_id = aws_subnet.ZoneB_Public_Subnet.id
  security_groups = [aws_security_group.My_VPC_Security_Group.id]
  availability_zone = var.availabilityZoneB
  user_data = <<-EOF
		#! /bin/bash
                sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	EOF
  tags = {
    Name = "HelloWorld"
  }
}
# end vpc.tf
