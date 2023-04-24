You have been given access to an AWS account with the following resources provisioned:

1 VPC with 1 public subnet and 1 private subnet in the us-east-1 region
1 EC2 instance running Ubuntu 20.04 in the private subnet
1 Elastic Load Balancer (ELB) in the public subnet
1 Route53 hosted zone for a domain name you own
1 Security Group attached to the EC2 instance with the following rules:
SSH access allowed from any IP address
HTTP access allowed from any IP address
You have been asked to complete the following tasks using the resources provided:

Create an S3 bucket named "test-bucket" in the us-east-1 region, with versioning enabled.
Write a script in Python, Bash or any other scripting language that will perform the following tasks:
Install Nginx web server on the EC2 instance
Configure Nginx to serve a default "Hello World" web page
Create an AMI of the EC2 instance
Using Terraform, create the following resources:
An Application Load Balancer (ALB) in the public subnet
A Target Group associated with the ALB
A Launch Configuration that uses the AMI created in step 2 to launch EC2 instances in the private subnet
An Auto Scaling Group that uses the Launch Configuration and Target Group to scale EC2 instances in the private subnet
A Route53 Record Set that maps the domain name you own to the ALB
The ALB should be configured to:

Listen on port 80 and forward traffic to the Target Group
Enable HTTP health checks to the Target Group
The Auto Scaling Group should be configured to:

Launch a minimum of 2 and a maximum of 4 EC2 instances
Use the Target Group to register and deregister EC2 instances
Scale based on CPU utilization, with a target of 50%
The Terraform code should be organized into modules and variables.

Write a script in Python, Bash or any other scripting language that will perform the following tasks:
Query the AWS CLI to get the current count of running EC2 instances in the private subnet
Send an email notification to a specific email address if the count is less than 2 or greater than 4
You can use any email service of your choice to send the email notification.