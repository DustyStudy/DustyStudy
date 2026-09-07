# Dusty

Open-source AWS cloud security tooling focused on **FedRAMP**, **NIST 800-53 Rev5**, multi-account governance, and practical day-to-day guardrails — including support for commercial and GovCloud partitions.

I build reusable CloudFormation & Terraform modules, auto-remediation patterns, observability dashboards, and credential/identity tooling that avoid long-lived access keys.

---

## The Suite

| Repository | Purpose |
|------------|---------|
| [**fedramp-terraform-library**](https://github.com/DustyStudy/fedramp-terraform-library) | Terraform modules implementing NIST 800-53 Rev5 Moderate/High controls + FedRAMP 20x KSIs |
| [**fedramp-cfn-library**](https://github.com/DustyStudy/fedramp-cfn-library) | CloudFormation counterpart of the above |
| [**aws-cloud-security-toolbox**](https://github.com/DustyStudy/aws-cloud-security-toolbox) | Practical guardrails, auto-remediation, AI/ML protections (CFN + TF) |
| [**aws-observability-dashboards**](https://github.com/DustyStudy/aws-observability-dashboards) | CloudWatch dashboards for security posture, Bedrock, agentic AI, NHI, EKS |
| [**aws-orgseed**](https://github.com/DustyStudy/aws-orgseed) | Multi-org account seeding via hub-and-spoke OIDC (no long-lived credentials) |
| [**aws-orgctl**](https://github.com/DustyStudy/aws-orgctl) | Ephemeral SSO / IAM Identity Center credential manager |
| [**ai-terraform-toolkit**](https://github.com/DustyStudy/ai-terraform-toolkit) | Security-hardened Terraform modules + Claude / Gemini AI workflows |

All libraries emphasize:

- FedRAMP-aligned controls and honest coverage-gap documentation
- GovCloud / partition awareness
- Short-lived credentials only (OIDC / SSO)
- CI security scanning (Checkov, Trivy, Gitleaks, tflint, etc.)

---

## Focus areas

- FedRAMP Moderate / High / 20x baselines
- Multi-account AWS Organizations governance
- AI/ML (Bedrock, SageMaker, agentic workloads) security
- Continuous monitoring & observability
- Zero long-lived credentials patterns
