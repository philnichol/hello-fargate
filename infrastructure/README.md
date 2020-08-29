# Hello-CTM Infra

This repo houses the infrastructure for Hello-CTM, it mainly consists of:
- 1 VPC
- 4 subnets (2 public, 2 private)
- 1 ALB
- 1 ECR
- 1 ECS cluster with a single service running
- Security groups
- IAM roles

## Backend
While testing locally the statefile is stored locally, but for a proper environment it would be stored in S3.

## for_each vs. count
When a loop was required and I felt it appropriate, I went with for_each instead of count.  
This allows the resources to be indexed via a key rather than just their order in a list.  
While more verbose, this means that changing an item in a list won't force a recreation of all other items in the list.