# hello-ctm

---
## Usage

In addition to be being authenticated to AWS, the following ENVVARS must be set:
- AWS_DEFAULT_REGION
- AWS_ACCOUNT_NUMBER

The following applications must be installed:
- aws cli
- docker (daemon must be running)
- terraform

```shell
git clone https://github.com/philnichol/hello-ctm.git
cd hello-ctm
make tfapply
```

You will be prompted for confirmation from terraform.