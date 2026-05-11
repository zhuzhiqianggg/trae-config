---
name: devops-terraform-engineer
description: Senior Terraform engineer skill for infrastructure as code across AWS, Azure, GCP. Use for module development, state management, provider configuration, multi-environment workflows, or infrastructure testing.
tags: [terraform, opentofu, iac, infrastructure, aws, azure, gcp, devops]
---

# Terraform Engineer

Senior Terraform engineering for infrastructure as code across AWS, Azure, and GCP.

## When to Use

- Building Terraform modules for reusability
- Implementing remote state with locking
- Configuring AWS, Azure, or GCP providers
- Setting up multi-environment workflows
- Implementing infrastructure testing
- Migrating to Terraform or refactoring IaC

## Core Workflow

1. **Analyze** — Review requirements, existing code, cloud platforms
2. **Design** — Create composable, validated modules with clear interfaces
3. **State** — Configure remote backends with locking and encryption
4. **Secure** — Apply least privilege, encryption, security policies
5. **Validate** — Run `terraform plan`, policy checks, automated tests

## Project Structure

```
infra/
├── environments/
│   ├── production/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── staging/
└── modules/
    ├── networking/
    ├── compute/
    └── database/
```

## Module Pattern

```hcl
variable "name" {
  description = "Resource name"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.medium"
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.name
  }
}

output "instance_id" {
  value = aws_instance.this.id
}
```

## State Management

```hcl
terraform {
  backend "s3" {
    bucket         = "myorg-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

## Security

| Must Do | Must Not Do |
|---------|-------------|
| Use remote state with locking | Store secrets in plain text |
| Encrypt state at rest and in transit | Use local state for production |
| Pin provider versions | Skip state locking |
| Validate all inputs | Hardcode environment values |
| Tag all resources for cost tracking | Mix provider versions without constraints |
| Use least-privilege IAM | Create circular module dependencies |

## Multi-Environment

```hcl
# environments/production/main.tf
module "networking" {
  source = "../../modules/networking"
  env    = "production"
  cidr   = "10.0.0.0/16"
}

module "compute" {
  source        = "../../modules/compute"
  name          = "app-prod"
  instance_type = "t3.large"
  subnet_id     = module.networking.public_subnet_ids[0]
}
```

## CI/CD

```yaml
jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - run: terraform fmt -check
      - run: terraform init
      - run: terraform validate
      - run: terraform plan
      - run: terraform apply -auto-approve
        if: github.ref == 'refs/heads/main'
```

## Testing

- `terraform validate` — syntax and structural validation
- `terraform plan` — preview changes before apply
- `tflint` — Terraform-specific linting
- `checkov` / `tfsec` — security policy as code
- `terratest` — integration tests for modules

## Verification

- [ ] Module structure: `main.tf` + `variables.tf` + `outputs.tf`
- [ ] Remote backend configured with state locking
- [ ] Provider versions pinned (`~> x.y`)
- [ ] Input validation blocks on all variables
- [ ] `terraform fmt` clean
- [ ] No hardcoded secrets (use `sensitive` + variables)
- [ ] Resources tagged for cost tracking
- [ ] `prevent_destroy` on critical resources (databases, state)
