# terraform-docker-ecs

This repository provides a tutorial to deploy a simple webapp (https://github.com/docker-training/webapp) to ASG cluster which utilizes ECS as its container service.

Blogpost: http://freedomofkeima.com/blog/posts/flag-9-scalable-deployment-with-terraform-docker-ecs

Advantage of using Terraform in managing ASG + ECS cluster with Docker:
- Scalability: We can simply add number of running instances in ASG and desired number of tasks in ECS
- Easy deployment and rollback: With Docker tag as version marker and ECS minimum healthy percent, we can specify it in Terraform to execute rolling update to our servers (See: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/update-service.html). One simple command and you can release your new web application anytime.


## Requirement

- Terraform (https://www.terraform.io/downloads.html)
- Set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variable in your local environment
 

## Directory structure

In our project, we divide Terraform configuration files into three main categories:
- `asg`: Autoscaling groups (ASG), Elastic Load Balancer (ELB), ECS fall into this category
- `common`: Common architecture which is rarely changed (VPC) but we still want to manage them with Terraform
- `static`: As the name suggests, we usually create this static configuration only once. Furthermore, we usually don't want to delete any resource from this category. IAM, DynamoDB tables, SQS queues, S3 bucket fall into this category

**Why do we separate our Terraform configuration files into three categories?**

**Reason 1**: Sometimes, we don't want to touch specific part of our environments after initial creation. For example, we don't want to destroy our DynamoDB Tables, IAM role, and SQS queues. That's why we create a specific `static` category for this scenario.

**Reason 2**: We want to deploy our application in several regions, let's say, `ap-northeast-1` a.k.a Tokyo and `ap-southeast-1` a.k.a Singapore. IAM role are global configuration which only needs to be executed one time while we may need to replicate `asg` to several environments.

**Reason 3**: For application versioning, we usually only change Docker tag version or instance's launch configuration. Therefore, we separate the category into two: `asg` and `common`. We don't want to touch our VPC for each deployment, which makes it reasonable to put these configurations under `common` category.

```
├── asg
|   ├── task-definition
|   |   ├── ecs_task_webapp.tpl
|   |   └── ... (another task definitions)
|   ├── autoscaling.tf
|   ├── autoscaling_user_data.tpl
|   ├── configuration.tfvars
|   ├── ecs.tf
|   ├── elb.tf
|   ├── output.tf
|   ├── vars.tf
|   └── ... (other ASG related files)
|
├── common
|   ├── configuration.tfvars
|   ├── output.tf
|   ├── security_groups.tf
|   ├── vpc.tf
|   ├── vars.tf
|   └── ... (other common related files)
|
└── static
    ├── iam
    |   ├── configuration.tfvars
    |   ├── iam.tf
    |   ├── output.tf
    |   └── vars.tf  
    └── ... (other AWS services: SQS, DynamoDB, etc)
```


## Deployment steps

For the first step, we need to deploy these environments in order: `static` --> `common` --> `asg`. After first deployment, our changes will usually happen in `asg` category, so we don't need to touch other environments anymore.

The workflow for each part is basically quite the same:

1. Modify configuration.tfvars variables
2. Run `terraform plan -var-file=configuration.tfvars` and confirm changes
3. Run `terraform apply -var-file=configuration.tfvars`


## Additional information

It's recommended to store `terraform.tfstate` remotely. In this case, you can share your current environment state with other members. You can utilize S3, Atlas, etc to store your tfstate. For further information, please read it at the official documentation: https://www.terraform.io/docs/commands/remote-config.html.

Not only that, you could simplify `asg` to use `common` environment as its remote state. All `outputs` from `common` will be consumed directly by `asg` and therefore you don't need to specify those values in `configuration.tfvars` any longer. For further information, please read it at the official documentation: https://www.terraform.io/docs/providers/terraform/r/remote_state.html.


## License

MIT License.

Last Updated: April 21, 2016
