name = $(shell grep -e name infrastructure/terraform.tfvars | cut -d '=' -f 2 | tr -d '[:space:]' | tr -d '\"')
env = $(shell grep -e env infrastructure/terraform.tfvars | cut -d '=' -f 2 | tr -d '[:space:]' | tr -d '\"')
image_tag = $(shell grep -e image_tag infrastructure/terraform.tfvars | cut -d '=' -f 2 | tr -d '[:space:]' | tr -d '\"')
region = $(shell grep -e region infrastructure/terraform.tfvars | cut -d '=' -f 2 | tr -d '[:space:]' | tr -d '\"')

checkdependencies:
	which aws \
		&& which docker \
		&& which python3 \
		&& which terraform \
		|| exit 1

checkvariables: checkdependencies
ifndef AWS_ACCOUNT_NUMBER
	$(error AWS_ACCOUNT_NUMBER is undefined)
endif

ifeq (, $(name))
	$(error name var not set)
endif
ifeq (, $(env))
	$(error env var not set)
endif
ifeq (, $(image_tag))
	$(error image_tag var not set)
endif

full_image_path := $(AWS_ACCOUNT_NUMBER).dkr.ecr.$(region).amazonaws.com/$(name)-$(env):$(image_tag)
repo_path := $(AWS_ACCOUNT_NUMBER).dkr.ecr.$(region).amazonaws.com

codelogin: checkvariables
	pushd code \
		&& aws ecr get-login-password --region $(region) | docker login --username AWS --password-stdin $(repo_path) \
		|| exit 1; \
		popd

codebuild: codelogin
	pushd code \
		&& docker build -t $(full_image_path) . \
		|| exit 1; \
		popd

codepush: codebuild
	pushd code \
		&& docker push $(full_image_path) \
		|| exit 1; \
		popd

tffmt: codepush
	pushd infrastructure \
		&& terraform fmt -recursive -list=true -check=true \
		|| exit 1; \
		popd

tfinit: tffmt
	pushd infrastructure \
		&& terraform init --reconfigure \
		|| exit 1; \
		popd

tfvalidate: tfinit
	pushd infrastructure \
		&& terraform validate \
		|| exit 1; \
		popd

tfapply: tfvalidate
	pushd infrastructure \
		&& terraform apply \
		|| exit 1; \
		popd