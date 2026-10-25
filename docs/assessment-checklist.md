# Assessment completion checklist

- [x] Next.js frontend and Python FastAPI backend source code
- [x] Containerized Dockerfiles for both applications
- [x] CloudFormation templates for networking, ECR, S3 artifacts, ECS, EC2, CodeDeploy and RDS
- [x] Separate app and infrastructure workflow files
- [x] Immutable SHA image/artifact naming in release workflows
- [x] Secrets Manager, private RDS and security group approach documented
- [x] Architecture, deployment, security and rollback documentation
- [ ] Run `cfn-lint` and resolve all findings in the target AWS region
- [ ] Deploy both approaches in a sandbox AWS account and record evidence
- [ ] Configure OIDC IAM trust, GitHub variables and protected environments
- [ ] Configure ACM TLS, DNS, WAF, alarms, dashboards and scaling policies
- [ ] Verify database migrations, backup/PITR restore and rollback procedures
- [ ] Replace any remaining account-specific assumptions and review costs

Do not claim the unchecked validation/deployment items are complete until they have been tested in an AWS account.
