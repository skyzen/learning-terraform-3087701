data "aws_ami" "labtest_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

# Create VPC
resource "aws_vpc" "labtest_vpc" {
  cidr_block = "10.0.0.0/16" 

  tags = {
    Name  = "labtest-vpc"
	  Owner = "ajain"
  }
}

# Create subnet within the VPC
resource "aws_subnet" "labtest_subnet" {
  vpc_id     = aws_vpc.labtest_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "labtest-subnet"
	  Owner = "ajain"
  }
}


# Create EC2 instances
resource "aws_instance" "labtest_instance" {
  count         = var.instance_count
  ami           = data.aws_ami.labtest_ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.labtest_subnet.id

  tags = {
    Name = "labtest-instance-${count.index + 1}"
    Owner = "ajain"
  }
}

# Create EBS volumes
resource "aws_ebs_volume" "labtest_volume" {
  count              = var.instance_count
  availability_zone  = aws_subnet.labtest_subnet.availability_zone
  size               = 20  # Provide volume size or make it a variable

  tags = {
    Name = "labtest-volume-${count.index + 1}"
    Owner = "ajain"
  }
}

# Attach EBS volumes to the instances
resource "aws_volume_attachment" "labtest_attachment" {
  count       = var.instance_count
  device_name = "/dev/xvdf"  # Provide device name or make it a variable
  volume_id   = aws_ebs_volume.labtest_volume[count.index].id
  instance_id = aws_instance.labtest_instance[count.index].id
}

# Create S3 bucket
resource "aws_s3_bucket" "labtest_bucket" {
  bucket = "labtest-bucket-ajain3"   # make sure to provide a unique name
  
  tags = {
    Owner = "ajain3"
  }
}