# Coditude DevOps Assessment — AWS

This repository implements the assessment design for a Next.js frontend, Python FastAPI backend and PostgreSQL database using two deployment models: ECS Fargate containers and EC2-hosted non-containerized services. CloudFormation defines infrastructure; GitHub Actions handles CI/CD; AWS CodeDeploy is the release mechanism for EC2 artifacts.

> Important: this repository is not deployed to an AWS account from this workspace. Before submission, validate the templates, configure account-specific values and IAM, deploy to a sandbox, and attach test evidence. Production use requires HTTPS, alarms, scaling policies, database migrations and recovery testing.

## Repository structure

- `apps/frontend/` — Next.js frontend and container image definition
- `apps/backend/` — FastAPI backend, health endpoint and optional database connectivity check
- `infra/templates/network.yaml` — VPC, two public and two private subnets, NAT gateways and routes
- `infra/templates/ecr.yaml` — immutable ECR repositories with image scanning and lifecycle policies
- `infra/templates/release-bucket.yaml` — encrypted/versioned private S3 artifact bucket
- `infra/templates/ecs-app.yaml` — ECS Fargate, ALB, task roles, logs and services
- `infra/templates/ec2-app.yaml` — ALB, EC2 Auto Scaling Groups, launch templates and CodeDeploy agent
- `infra/templates/codedeploy.yaml` — CodeDeploy application, frontend/backend deployment groups and rollback on failed deployments
- `infra/templates/database.yaml` — private encrypted PostgreSQL RDS with managed credentials and backup retention
- `.github/workflows/` — independent frontend, backend, infrastructure and EC2 release workflows
- `docs/` — architecture, deployment, security, rollback and checklist

## Deployment models

1. **Containerized:** ECR → ECS Fargate services in private subnets → ALB. RDS is private. SHA-tagged images are deployed to only the affected ECS service.
2. **Non-containerized:** Next.js and Python run on EC2 instances in separate Auto Scaling Groups behind an ALB. GitHub Actions packages the selected component, uploads it to S3, and invokes CodeDeploy. RDS is private.

## CI/CD separation

Application workflows trigger only for their component paths and update only the corresponding service. Infrastructure validation/deployment lives in a separate workflow and is manually dispatched. App-only deployments do not invoke CloudFormation. EC2 releases are manually triggered by component and do not modify infrastructure.

## Prerequisites

AWS account, GitHub repository, AWS CLI v2, Docker, Python 3.12+, Node.js 20+, CloudFormation linting, ECR repositories, an OIDC IAM role, a release S3 bucket, and CodeDeploy application/deployment groups for the EC2 option.

## Before deploying

1. Review the architecture and deployment docs.
2. Configure GitHub variables and OIDC role trust; protect staging/production environments.
3. Run template linting and application builds.
4. Deploy network and application/database stacks with explicit parameters. The database stack requires the actual VPC, private subnet IDs, and app security group ID.
5. For ECS, pass the RDS endpoint and secret ARN into the compute stack. For EC2, configure CodeDeploy deployment groups with `Component` and `Environment` tag filters.
6. Configure ACM HTTPS, WAF, monitoring alarms, scaling policies and database recovery testing before production exposure.

See `docs/deployment.md` for commands and `docs/security-rollback.md` for security and recovery details.
