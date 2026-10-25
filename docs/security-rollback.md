# Security and rollback

## Security

- GitHub Actions authenticates with AWS using OIDC; no long-lived AWS keys are stored in GitHub. Scope the role to repository, branch and environment.
- Run workloads in private subnets. Public ingress terminates at the ALB. Database ingress is limited to the application security group on TCP 5432.
- RDS storage encryption is enabled and RDS manages the master credential in Secrets Manager. The ECS execution role receives read access to the configured DB secret only. Do not use the master account for application queries in a mature production deployment; create a separate least-privilege application DB user.
- EC2 requires IMDSv2. Use SSM Session Manager instead of SSH, and avoid inbound port 22. Keep secrets out of image layers, logs, artifacts and source control.
- Configure ACM/TLS, WAF, ECR image scanning, dependency scanning, CloudTrail and AWS Config before production use.

## Rollback

- ECS: retain previous task definition revisions and immutable SHA image tags. Roll back by updating the affected service to the previous task definition revision and verify the service reaches steady state.
- EC2/CodeDeploy: configure CodeDeploy automatic rollback on deployment failure and retain prior S3 artifact versions. Trigger a deployment of the last known-good artifact.
- Infrastructure: inspect CloudFormation change sets before applying. Use stack rollback for failed updates; do not delete production stacks to recover. Resources with data should have retention/snapshot policies.
- Database: enable automated backups and point-in-time recovery; test restore procedures. Schema changes must be backward compatible during the rollback window.
- Validate `/health`, application logs, ALB target health and error rates after rollback.
