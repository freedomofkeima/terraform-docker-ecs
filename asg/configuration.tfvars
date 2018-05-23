##
# Some of these variables may be removed from this file if the default value exists
# For better understanding, let's specify all variables explicitly here
##
name_prefix = "tutorial-test"
aws_region = "ap-northeast-1"
ecs_image_id.ap-northeast-1 = "ami-68ef940e"
count_webapp = 2
desired_capacity_on_demand = 2
ec2_key_name = "key-name"
instance_type = "t2.micro"
minimum_healthy_percent_webapp = 50
launch_type = "EC2" # can also be "FARGATE"
##
# This is a sample (public) Docker image from which can be accessed at https://github.com/docker-training/webapp
# This sample image utilizes Flask and it's not RECOMMENDED to run it directly in production (performance degradation)
# This web server binds to port 5000
##
webapp_docker_image_name = "training/webapp"
webapp_docker_image_tag = "latest"

##
# These variables are required, please fill it out with your environment outputs or use remote state references
##
sg_webapp_albs_id = "sg-12345678"
sg_webapp_instances_id = "sg-23456789"
vpc_id = "vpc-aabbccdd"
subnet_ids = "subnet-34567890,subnet-4567890a"

ecs_instance_profile = "arn:aws:iam::123456789012:instance-profile/tutorial-test_ecs_instance_profile"
ecs_service_role = "tutorial-test_ecs_service_role"
ecs_task_execution_role  = "arn:aws:iam::123456789012:role/tutorial-test_ecs_task_execution_role" # only used with launch type FARGATE
