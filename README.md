[![CI/CD Deployment Status](https://github.com/abeganovic/task-interview/actions/workflows/prod-app-deployment.yaml/badge.svg)](https://github.com/abeganovic/task-interview/actions/workflows/prod-app-deployment.yaml)  

# Interview task assignment

Version: 1.0  
Author: Alma Beganovic - Kazija  
Application is available via the following url http://alma-interview-prod-912370085.eu-central-1.elb.amazonaws.com/ (ALB Endpoint)  

This is a monorepo used for the interview task assigmed.

`app` - directory which contains all the application files  
`terraform`- directory which contains all te IaC files  
`helpers` - direcotry which contains supporting scripts and files (i.e. cloudformation template to create infra required for tf state file S3, DynamoDB)  

## Task 1:
Review Dockerfile received as attachment. 

Solution:
- I have reviewed the Dockerfile that was sent to me and left my comments inside the`Dockerfile.review.md` file.
- I have created a `Dockerfile.base` file which could be use as a base / golden image for our application image
- I have created a `Dockerfile.app` file which is our application docker image.
- I have created a `Dockerfile` file which use multi stage build
- I have created `app.py` file to showcase that app is acutaly running.
- For the task 2 we will use `Dockerfile` to build and deploy application docker image

## Task 2:
Create a GitHub repository for creating and deploying this Docker container using Terraform + a pipeline (you can choose the tool). Please use AWS ECS Fargate for this and of course you do not have to take care of networking, user management etc.

### CI/CD
For the CI/CD i have used github actions to do following:
- Pull request checks (to genereate terrafrom docs and to check terraform code formating)
- I have alos integrated [renovatebot](https://github.com/renovatebot/renovate) to do dependiencies checks. 
- For all the secrets i have used Github secrets and for the env vars i have used Github environment variables.

#### Further Improvments
- Add github action to perfrom terraform plan and terraform apply 
- Use OpenID Connect to authenticate with AWS so that we can avoid using AWS Secret Key and AWS Secret Access Key in Github secrets.  

## AWS Infrastructure
For this task i have created new AWS account in which i have deployed all the infrastructure required. 

## Networking
In the `Task 2` assignment is stated not to create netowrking. I have created a custom VPC for two resons:
- To create private subnets and put our tasks in private subnets
- To avoid using default VPC which is in general bad practice
- To create a custom VPC i have used VPC module from terraform registry which is heavily used, well documented and maintaned

## ECS Overview
- To create ECS Fargate cluster i have used ECS module from the terraform registry which is heavily used, well documented and maintaned  
- Cluster is tagged as `production` due to the env var value in the original Dockerfile i have received for review, but to keep our costs mininaml i have limited cluster to only one task running. If this is "real" production environment we would have min 2 tasks running to ensure HA. 

## Secret Manager
To manage our secrets i have used Secret Manager, for that i have created my own mudle. 
As a improvment we could move this module to the separate github repo, to ensure proper maintaince and versioning and also to enable others to use it. For this purpose this is a simple module just to showcase usage of own modules.

#### Further Improvments
- Currently we have only HTTP lisner for our ALB, to improve it we would need to add SSL cert from ACM and use HTTPS lisner 
- Add dns record in Route 53 
- Improve repo structure (i.e. use separate directories for shared resources like VPC)

## Pre commit hooks
To ensure proper formating of our Terrafrom code we are using `pre-commit` hooks. Currently we have implemented following `pre-commit` hooks:

- `terraform_fmt`  
- `terraform_docs`  

Pre commits are also executed using github actions. 
