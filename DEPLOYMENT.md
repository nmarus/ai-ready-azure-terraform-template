# Deployment Guide

## Prerequisites

Before deploying, ensure you have:

- **Azure Account** with permissions to create resources
- **Terraform** ≥ 1.14.0 installed
- **Azure CLI** configured with appropriate credentials

## Configuration Setup

### Step 1: Authenticate to Azure

```bash
az login
az account list --output table
az account set --subscription "<your-subscription-id>"
```

Verify your authentication:

```bash
az account show
```

### Step 2: Create terraform.tfvars

Copy the example file and customize for your environment:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and update the required variables.

### Step 3: Validate Configuration

```bash
# Initialize Terraform
terraform init

# Format code
terraform fmt -recursive

# Validate configuration
terraform validate
```

## Deployment

### Standard Deployment Process

```bash
# Review what will be created
terraform plan -out=tfplan

# Apply the infrastructure
terraform apply tfplan
```

### With Pre-commit Hooks (Recommended)

First-time setup:

```bash
# Install pre-commit hooks
pre-commit install

# Run all hooks manually (optional, runs automatically on commit)
pre-commit run --all-files
```

The hooks will automatically:
- Format Terraform files (`terraform_fmt`)
- Validate syntax (`terraform_validate`)
- Run TFLint linter (`terraform_tflint`)
- Generate/update documentation (`terraform_docs`)
- Scan for security issues (`terraform_checkov`)
- Check for common issues (trailing whitespace, merge conflicts, large files, private keys)

## Post-Deployment

### Retrieve Configuration

After successful deployment, retrieve the connection details configuration:

```bash
# Get the configuration as a json object
terraform output -json
```

## Cleanup

To destroy all infrastructure:

```bash
terraform destroy
```

**Warning:** This will delete:
- Transit Gateway and all attachments
- VPN connections
- CloudWatch alarms
- Lambda function and IAM roles
- CloudWatch log group

Confirm the destruction when prompted.

## Troubleshooting

### Terraform Init Fails

```bash
# Ensure Azure credentials are configured
az login

# Verify Terraform version
terraform version
```

### Pre-commit Hooks Failing

- **TFLint errors**: Review the linter output and fix resource naming or configuration issues
- **Checkov warnings**: These are security best practices; review and adjust based on your security posture
- **Terraform validate fails**: Check variable values in `terraform.tfvars`

## CI/CD Integration

The project includes configurations for automated validation:

- `.tflint.hcl` — Terraform linting rules
- `.pre-commit-config.yaml` — Pre-commit hook definitions
- Security scanning via Checkov

These can be integrated into CI/CD pipelines (GitHub Actions, GitLab CI, Jenkins, etc.) to automatically validate and test changes before deployment.
