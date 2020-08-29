# hello-ctm

## The task
Create a clustered web service in AWS that respond to a GET request with "hello world" and the date and time.


## Pipeline
In order to be able to test this locally and keep things platform-agnostic, I went with a Makefile.  
I haven't really worked much with Makefiles before so this was a good learning experience, picked it up from some colleagues at work. 
ECR has to be deployed before code due to a chicken/egg scenario since it has to exist before the docker image can be pushed.  
I don't have a Jenkins instance to test on, so not sure it will work, but it should be close enough (may have to tweak the TF apply steps to allow user confirmation). I also haven't built the CI agent that will run the pipeline (figured it was out of scope)

---
## Usage (running locally)

In addition to be being authenticated to AWS, the following ENVVARS must be set:
- AWS_DEFAULT_REGION
- AWS_ACCOUNT_NUMBER

The following applications must be installed:
- aws cli
- docker (daemon must be running)
- terraform

To deploy everything:
```shell
git clone https://github.com/philnichol/hello-ctm.git
cd hello-ctm
make all
```

To destroy the infra:
```shell
make destroy
```

You will be prompted for confirmation from terraform.