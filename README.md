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
- I have reviewed the Dockerfile that was sent to me and left my comments inside the`Dockerfile.review` file.
- I have created a `Dockerfile.base` file which could be use as a base / golden image for our application image
- I have created a `Dockerfile.app` file which is our application docker image.
- I have created a `Dockerfile` file which use multi stage build
- I have created `app.py` file to showcase that app is acutaly running.
- For the task 2 we will use `Dockerfile` to build and deploy application docker image

## Task 2:
Create a GitHub repository for creating and deploying this Docker container using Terraform + a pipeline (you can choose the tool). Please use AWS ECS Fargate for this and of course you do not have to take care of networking, user management etc.

## ECS Overview

TO DO: add

## Network Overview
TO DO: add

## Coding Standards
To ensure proper formating of our Terrafrom code we are using `pre-commit` hooks. Currently we have implemented following `pre-commit` hooks:

`terraform_fmt` `terraform_docs`

Pre commits are executed using github actions. If you want to run pre-commit hooks localy (on Mac) use following command: brew install pre-commit and then run `pre-commit` command using

`pre-commit run -a`
```
Terraform fmt............................................................Passed
Terraform docs...........................................................Passed
```
For more informations about pre-commit-terraform check following [link](https://github.com/antonbabenko/pre-commit-terraform)

## Future Improvments
- move secrets manager into modules
- implement Github OCID for github actions (currently i am using github secrets to store aws keys which is bad)
- add https lisner and SSL from ACM
- add dns record in route 53