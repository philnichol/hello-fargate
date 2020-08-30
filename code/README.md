# Hello-CTM Code

## This folder consists of possibly the most basic flask app ever created and a Dockerfile

## Flask
Just returns a greeting and the time, while there are defaults, you can pass in a custom greeting and time format via ENV VARS.

# Docker
- Uses alpine as a base to keep the image small and reduce attack vector
- Uses a multi-stage docker container to keep compile-time dependencies out of the runtime image
- Since it runs on Fargate, curl has to be installed for healthchecks. If ever moved to k8s this can be removed. 

# Tests
A few basic tests are run against the code before pushing the image to ECR.
