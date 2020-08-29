# hello-ctm

## The task
Create a clustered web service in AWS that respond to a GET request with "hello world" and the date and time.


## Pipeline
In order to be able to test this locally and keep things platform-agnostic, I went with a Makefile.  
I haven't really worked much with Makefiles before so this was a good learning experience.

---
## Usage

In addition to be being authenticated to AWS, the following ENVVARS must be set:
- AWS_DEFAULT_REGION
- AWS_ACCOUNT_NUMBER

The following applications must be installed:
- aws cli
- docker (daemon must be running)
- terraform

To create the infra:
```shell
git clone https://github.com/philnichol/hello-ctm.git
cd hello-ctm
make tfapply
```

To destroy the infra:
```shell
make tfdestroy
```

You will be prompted for confirmation from terraform.