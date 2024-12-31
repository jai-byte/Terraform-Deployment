Project Title: AWS Infrastructure Automation and API Setup

This repository demonstrates how to automate the provisioning of AWS resources and the deployment of a simple Flask-based API service. Using Terraform for infrastructure as code (IaC), it sets up the following:
An S3 bucket with policies for EC2 access.
An IAM role for EC2 to access the S3 bucket.
An EC2 instance configured with the required dependencies (Python, Flask, and Boto3).
A deployed API service to interact with the S3 bucket.
