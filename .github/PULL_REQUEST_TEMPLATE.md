## Description

Please include a summary of the changes and the related issue. List any dependencies that are required for this change.

### This pull request contains the necessary configuration to set up a Serverless Database-info API.

Terraform files are provided to deploy the infrastructure in AWS. This includes:

1. The necessary VPC configuration.
2. An RDS PostgreSQL instance.
3. The necessary IAM roles and policies.
4. A Lambda function that generates logs in CloudWatch.
5. An API Gateway REST API.
6. An SNS topic triggered by RDS infrastructure status alarms.
7. Application code for the Lambda function.
8. The Lambda Layer to import the packages to connect to the RDS.
9. A Dockerfile and docker-compose file to deploy a local testing environment.
10. .sql scripts to test the RDS alarms.
11. A comprehensive README.md file.



Closes #1: Serverless Database-info API deployment

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [x] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [x] Documentation update

## How Has This Been Tested?

Please describe the tests that you ran to verify your changes. Provide instructions so we can reproduce.

- [x] Local function test: 

1. Build and run the containers:
```
cd docker
docker-compose up --build -d
```

2. Once they are running execute the following command:
```
curl -XPOST 'http://localhost:9000/2015-03-31/functions/function/invocations' \
     -H 'Content-Type: application/json' \
     -d '{"httpMethod": "GET", "queryStringParameters": null, "body": null}'
```

3. The expected result is a status code 200 OK and a JSON body containing information regarding the database version.
- [x] Live integration test:

1. Check the following variables in the terraform.tfvars file and assign values to them:
```
sns-email = ""
my-public-ip = ""
```
2. Initiate and validate
```
terraform init
terraform validate
```
3. Run Pre-Deployment Checks
```
tflint
trivy config .
```
4. Deployment
Review the planned changes and apply the configuration.
```
terraform plan
terraform apply
```
5. Testing
After deployment, copy the URL of the API Gateway given by the output and paste it into your browser.

The command should return a 200 OK status code and a JSON body confirming the connection to the live RDS instance and its version

## Checklist

- [x] My code follows the style guidelines of this project
- [x] I have performed a self-review of my code
- [x] I have commented my code, particularly in hard-to-understand areas
- [x] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [x] Any dependent changes have been merged and published in downstream modules
- [x] I have checked my code and corrected any misspellings
