# AWS-EC2-Web-Server-With-ALB
VPC with public/private subnets across multiple AZs  Internet Gateway &amp; NAT Gateway for outbound access from private instances  Application Load Balancer in public subnets, routing HTTP traffic to EC2 in private subnets  Auto Scaling Group of Amazon Linux 2023 EC2 instances running Nginx SSM/IAM Access.

## Prereqs
- Terraform >= 1.5
- AWS CLI configured; an admin or sufficient IAM perms. Region default: `us-east-1`.

## How to Run
```bash
terraform init
terraform plan
terraform apply -auto-approve
```
Grab the output `alb_dns_name` and visit it in your browser or:
```bash
curl http://$(terraform output -raw alb_dns_name)
```

## Accessing Private Instances (Optional)
Use **SSM Session Manager** (no keys/bastion):
```bash
aws ssm start-session --target <instance-id> --region <your-region>
```

## Cost Note
NAT Gateway and ALB incur hourly + data processing charges. Destroy when done.

## Cleanup
```bash
terraform destroy -auto-approve
```

## Troubleshooting
- **Health checks failing**: Wait ~2–3 minutes after create; ensure user data installed Nginx and SG allows ALB→EC2 on 80.
- **No internet for instances**: Private route table must point `0.0.0.0/0` to the NAT GW; verify.
- **ALB 5xx**: Check target group health, ASG capacity, Nginx service status.

##RUN
```bash
terraform init
terraform apply -auto-approve
curl http://$(terraform output -raw alb_dns_name)
```
##SHELL INTO INSTANCE
```bash
aws ssm start-session --target <instance-id> --region us-west-1
```


