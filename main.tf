# Provider Configuration
provider "aws" {
  region = "us-east-1" # Change to your region
}


# Security Group for HTTP Access
resource "aws_security_group" "http_sg" {
  name        = "http-service-sg"
  description = "Allow HTTP traffic"


  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPs. Change this for more restricted access.
  }
  
  ingress {
    description = "Allow SSH"
    from_port   = 3366
    to_port     = 3366
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPs. Change this for more restricted access.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role and Policy for S3 Access
resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name = "ec2-s3-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["s3:ListBucket", "s3:GetObject"],
      Effect   = "Allow",
      Resource = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# EC2 Instance
resource "aws_instance" "http_service" {
  ami           = "ami-01816d07b1128cd2d" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "http-key" # Replace with your key pair

  security_groups = [aws_security_group.http_sg.name]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y python3 python3-pip
  sudo pip install flask boto3

  # Write the app.py script to the correct location
  cat <<EOT > /home/ec2-user/app.py
  ${file("${path.module}/app.py")}
  EOT
  python3 /home/ec2-user/app.py &
EOF


  tags = {
    Name = "my-server-http"
  }
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# Output the EC2 public IP
output "instance_public_ip" {
  value = aws_instance.http_service.public_ip
}
