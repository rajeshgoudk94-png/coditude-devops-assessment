# Deployment and CI/CD

## Change separation

- `apps/frontend/**` runs frontend tests/build, pushes a SHA-tagged image, and updates only the frontend ECS service.
- `apps/backend/**` runs backend checks, pushes a SHA-tagged image, and updates only the backend ECS service.
- `infra/**` runs `cfn-lint`; actual CloudFormation deployment is a separate manual workflow dispatch and is not called by application workflows.
- The non-containerized release workflow is manual, packages only the selected component, uploads an immutable artifact to S3, and starts the matching CodeDeploy deployment group.

## GitHub repository/environment variables

Set `AWS_ROLE_ARN`, `AWS_REGION`, `DEPLOY_ENV`, `ECR_FRONTEND_REPOSITORY`, `ECR_BACKEND_REPOSITORY`, `ECS_CLUSTER`, `ECS_FRONTEND_SERVICE`, `ECS_BACKEND_SERVICE`, `RELEASE_BUCKET`, `CODEDEPLOY_APPLICATION`, `CODEDEPLOY_FRONTEND_GROUP`, and `CODEDEPLOY_BACKEND_GROUP`. Configure a GitHub OIDC trust relationship restricted to this repository and allowed branch/environment. Configure staging and production as protected GitHub Environments.

## CloudFormation order

1. Deploy `network.yaml` and record `VpcId`, `PublicSubnetIds`, and `PrivateSubnetIds` outputs.
2. Deploy `ecr.yaml` for the containerized path and `release-bucket.yaml` for the EC2 path.
3. Deploy compute stack (`ecs-app.yaml` or `ec2-app.yaml`) to create the application security group.
4. Deploy `database.yaml` with the VPC, private subnet IDs, and application security group ID.
5. For ECS, update the compute stack parameters with the RDS endpoint and managed secret ARN so the backend receives DB settings. In a refined production stack, place the shared application security group in its own stack to avoid ordering dependencies.
6. For EC2, deploy `codedeploy.yaml` with the frontend and backend Auto Scaling Group names, then set GitHub variables from its outputs. The template creates CodeDeploy deployment groups using component/environment tag filters and rollback on deployment failure. Configure the S3 artifact bucket and its access policy.

Because CloudFormation references are cross-stack values, pass outputs explicitly as parameter overrides. Do not copy secrets into parameters or source control.

## Validation

```bash
pip install cfn-lint
cfn-lint infra/templates/*.yaml
aws cloudformation validate-template --template-body file://infra/templates/network.yaml
python -m compileall apps/backend
cd apps/frontend && npm ci && npm run build
```

Use a change set and a protected environment approval for Staging/Production. The current infrastructure workflow supports manual stack deployment; supply the required template parameters for the selected template.
