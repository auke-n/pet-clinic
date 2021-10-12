## This is an architecture for deploying pet-clinic application:

#### Prerequisites:

- AWS Account
- IAM User with Access Key & Secret Key
- AWS CLI (Download)
- Terraform (Download)

1. **Configure local machine:**

- Install AWS CLI
- Open terminal (linux/mac)/command prompt(windows)
- Run `*aws configure*`
- Provide the `*access key, secret key*` and `*region*` as requested
- Unzip downloaded terraform file
- Add terraform executable file to your environment variable (Optional)
- In working directory create file `*connection.tf*` to configure provider
- In working directory create file `*backend.tf*` to configure S3 bucket to store terraform.tfstate file
- Run `*terraform init*` command
- Run `*terraform apply*` command. Provide yes as input when asked and hit enter

2. **Terraform Infrastructure:**

- AWS region - eu-central-1 (Frankfurt)
- S3 bucket to store terraform.statefile
- EC2-instance with attached IAM role and permissions allowing SSM-connection
- Configured network in AWS cloud
- Configured security groups to determine remote connection to EC2-instance
- Application Load Balancer
- Route53 for DNS records and ACM for SSL certificate

![AWS (2)](https://user-images.githubusercontent.com/43706100/136904212-c66734a3-06a6-42e1-b840-675932d06500.png)
