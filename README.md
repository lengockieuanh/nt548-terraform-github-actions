# Infrastructure as Code with Terraform and GitHub Actions

This repository contains Terraform configurations to deploy AWS infrastructure with automated CI/CD using GitHub Actions and security scanning with Checkov.

## Prerequisites

- AWS Account and IAM credentials
- Terraform v1.0 or later
- Git
- Visual Studio Code
- WSL (Windows Subsystem for Linux)
- Python 3.x (for Checkov)

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── terraform.yml          
├── modules/
│   ├── ec2/
│   │   ├── main.tf               
│   │   ├── variables.tf          
│   │   └── outputs.tf            
│   ├── iam/
│   │   ├── main.tf               
│   │   ├── variables.tf          
│   │   └── outputs.tf            
│   ├── nat_gateway/
│   │   ├── main.tf               
│   │   ├── variables.tf          
│   │   └── outputs.tf            
│   ├── route_tables/
│   │   ├── main.tf               
│   │   ├── variables.tf          
│   │   └── outputs.tf            
│   └── vpc/
│       ├── main.tf               
│       ├── variables.tf      
│       └── outputs.tf            
├── .gitignore                    
├── main.tf                       
├── outputs.tf                    
├── variables.tf                  
├── versions.tf                   
└── README.md                     
```

## Steps to Run the Source

1. **Clone Repository**
```bash
git clone https://github.com/lengockieuanh/nt548-terraform-github-actions.git
cd nt548-terraform-github-actions
```

2. **Initialize Terraform**
```bash
terraform init
```

3. **Deploy Infrastructure**
```bash
terraform plan
terraform apply -auto-approve
```

## GitHub Actions Integration

1. Add repository secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. Workflow triggers on:
   - Push to main branch
   - Pull request to main branch

3. Workflow steps:
   - Code formatting check
   - Security scan with Checkov
   - Infrastructure plan and apply

## SSH Access Guide
1. **Set Key Permissions**
```bash
chmod 400 <private-key-file>
```

2. **Access Public Instance**
```bash
ssh -i <private-key> <username>@<public-ip>
```

3. **Transfer Key to Public Instance**
```powershell
scp -i <private-key> <private-key> ubuntu@<public-ip>:/home/ubuntu/.ssh/
```

4. **Access Private Instance**
```bash
# From public instance
cd ~/.ssh
chmod 400 ~/.ssh/
ssh -i ~/.ssh/<private-key> <username>@<private-ip>
```

## Security Considerations

- Security groups configured for minimal access
- Private subnet instances not directly accessible
- Checkov scanning integrated in CI/CD pipeline
- IAM roles follow principle of least privilege

## Cleanup

To destroy all created resources:
```bash
terraform destroy -auto-approve
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

