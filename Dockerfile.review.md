# Dockerfile Review
Task 1: Review following docker file.
```dockerfile
FROM python:latest
MAINTAINER example@example.com
RUN apt-get update && apt-get install -y \
    gcc \
    make \
    wget \
    nano \
    netcat \
    telnet \
    ftp
RUN echo "db_password=supersecret" >> /root/.env
COPY . .
RUN pip install flask boto3 numpy pandas requests
RUN chmod -R 777 /
ENV AWS_SECRET_ACCESS_KEY="1234567890" \
    API_KEY="abcdef" \
    ENVIRONMENT="production"
CMD ["python", "app.py", "--username=admin", "--password=admin123"]
```
## Dockerfile review

```dockerfile
FROM python:latest
```

- I would avoid using the 'latest' tag for the Python Docker image, as it doesn't provide control over the specific version being used.
- Additionally, we cannot control when the image will be updated.
- Whenever the vendor releases a new version, it will be pulled automatically, and it could break our application.
- An additional question is whether we really need a base image with all the Debian packages in it, or if we can use the slim version of the image, which will be smaller in size and will have only the required packages.
- Also, by using base images built by other people, we don't have control over the image and we don't know what is inside the image.
- The image can contain security vulnerabilities, and if we do a simple scan, we can see that this image has several high-severity issues.

```bash
trivy image --severity HIGH python:latest
Total: 112 (HIGH: 112)
```

- Instead, I would recommend building our own base image, which would be tagged using our own tagging policy, and then pushing that image to Amazon ECR.
- Currently, we are pulling the image from Docker Hub, which could lead to an issue where we hit the image pull API rate limit.
- This could break the CI/CD pipeline, and we would need to have a workaround in place.
- By using Amazon ECR, we would avoid rate limit issues.

```dockerfile
MAINTAINER example@example.com
```

- I think this is deprecated.
- Here is a source from the documentation: https://docs.docker.com/reference/build-checks/maintainer-deprecated/
- Based on that, I would recommend using LABEL instead of MAINTAINER.
- Example: `LABEL maintainer="example@example.com"`

```dockerfile
RUN apt-get update && apt-get install -y \
    gcc \
    make \
    wget \
    nano \
    netcat \
    telnet \
    ftp
```

- After trying to build this image, I got an error: `3.479 E: Package 'netcat' has no installation candidate`.
- In the output of the build command, I noticed that the correct netcat package name is either `netcat-traditional` or `netcat-openbsd`.
- Instead of installing packages each time we build our Docker image, we should install the required packages as part of the base Docker image.
- This means we need to create a base Docker image that contains the required Python version and necessary packages.
- By doing this, we would save time when building our Docker images and running CI/CD pipelines, which leads to faster release cycles.
- Also, for security reasons, I would recommend specifying the version of each package.
- This allows us to control which versions are being installed and helps in tracking any vulnerabilities related to specific package versions.

```dockerfile
RUN echo "db_password=supersecret" >> /root/.env
```

- We should avoid using hardcoded values for environment variables, especially secrets, and avoid keeping secrets in Git.
- By using `echo`, this secret may also appear in CI/CD pipeline execution logs during the image build process.
- To solve this, I would suggest using environment variables to manage secrets, and storing secrets in AWS Secrets Manager.
- Later, we can retrieve secrets from AWS Secrets Manager and pass them to the Amazon ECS task definition.
- If, for any reason, we need the `db_password` secret available in our Docker image during the CI/CD pipeline—for example, to run tests—we can use GitHub Actions secrets or AWS Secrets Manager to securely provide the secret.
- Keeping secret values in a `.env` file within the Docker image is not a good practice. 
- If someone gains access to the Docker image, they will also have access to the DB password.
- Instead, we should use environment variables like: `db_password=$DB_PASSWORD`

```dockerfile
COPY . .
```

- We are using the COPY command to copy files from the host machine to the root of Docker image.
- We should probably copy only the required files and not the entire project
- Currently, we are copying all files from the host machine to the root directory of the Docker image.
- Instead, we should use the WORKDIR directive to set the working directory for the container and copy the files there.
- Example of the WORKDIR directive: `WORKDIR /app`

```dockerfile
RUN pip install flask boto3 numpy pandas requests
```
- We can move all the requirements to the `requirements.txt` file instead of installing them directly in the Dockerfile.
- This makes dependency management easier and cleaner, and allows us to take advantage of Docker layer caching.
- Example:
  ```dockerfile
  COPY requirements.txt .
  RUN pip install -r requirements.txt
  ```

```dockerfile
RUN chmod -R 777 /
```
- Changing permissions to 777, which gives all users read, write, and execute access to all files and directories, is a security risk.
- If we need to change permissions, we should use a specific user and apply the changes only to the required files and directories.
- I doubt we need permissions this wide open (777).
- I would recommend removing this line.

```dockerfile
ENV AWS_SECRET_ACCESS_KEY="1234567890" \
    API_KEY="abcdef" \
    ENVIRONMENT="production"
```
- We should not keep AWS_SECRET_ACCESS_KEY, ACCESS_KEY, or any sensitive credentials in the Dockerfile, the Git repository, or inside the Docker image.
- If, for any reason, we need to communicate with AWS services or APIs during the build process, we can use OpenID Connect (OIDC), which allows secure access without hardcoding AWS credentials.
- For our container to communicate with AWS services when using Amazon ECS, we should use IAM roles attached to the ECS task.
- The environment variable `ENVIRONMENT` should not be hardcoded. Instead, it should be passed as a parameter so we can reuse the same Dockerfile for different environments.
- The value of the `ENVIRONMENT` variable can be passed as a parameter using the `docker run` command or defined in the ECS task definition.

```dockerfile
CMD ["python", "app.py", "--username=admin", "--password=admin123"]
```  
- We should change this to something like:
  ```dockerfile
  ENTRYPOINT ["python", "app.py"]
  ```
- The ENTRYPOINT instruction sets the default executable for the container.
- Any arguments supplied to the `docker run` command are appended to the ENTRYPOINT command.

```dockerfile
CMD ["--username=$USERNAME", "--password=$PASSWORD"]
```

- The CMD instruction can be used to provide default arguments to an ENTRYPOINT when specified in exec form.
- This setup allows ENTRYPOINT to define the main executable, and CMD to provide additional arguments, which can be overridden by the user.
- We should use environment variables as parameters to the `app.py` file.
- By doing this, instead of hardcoding the username and password, we can provide them as environment variables at container runtime.