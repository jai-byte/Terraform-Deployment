Project Title: AWS Infrastructure Automation and API Setup

This repository demonstrates how to automate the provisioning of AWS resources and the deployment of a simple Flask-based API service. Using Terraform for infrastructure as code (IaC), it sets up the following:
An S3 bucket with policies for EC2 access.
An IAM role for EC2 to access the S3 bucket.
An EC2 instance configured with the required dependencies (Python, Flask, and Boto3).
A deployed API service to interact with the S3 bucket.

Steps Implemented
1. S3 Bucket Creation
Created an S3 bucket for storage.
Configured a policy allowing the specified EC2 instance to access the bucket for GET, PUT, and LIST operations.

2. IAM Role for EC2
Created an IAM role with an inline policy to grant the EC2 instance access to the S3 bucket.
Attached the role to the EC2 instance during its creation.

3. EC2 Instance Configuration
Used Terraform to provision an EC2 instance with the following configurations:
Installed Python 3.
Installed necessary Python packages (Flask and Boto3) for API and AWS SDK interaction.
Deployed the Python app.py script that implements the API service.
Verified that the instance was set up correctly.

4. API Deployment and Testing
Deployed a Flask application on the EC2 instance that interacts with the S3 bucket.
Verified API responses using:
Postman for API request testing.
A web browser for simple GET request verification.

5. Terraform for Infrastructure as Code
Utilized Terraform to:
Define and provision S3 buckets, IAM roles, and policies.
Launch the EC2 instance.
Automate resource configurations.

Typing...





