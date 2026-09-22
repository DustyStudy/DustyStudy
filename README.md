# Dusty

Open-source AWS cloud security tooling focused on **FedRAMP**, **NIST 800-53 Rev5**, multi-account governance, and practical day-to-day guardrails — including support for commercial and GovCloud partitions, Azure and GCP baselines, plus GRC evidence automation and LLM-agent security.

I build reusable CloudFormation & Terraform modules, auto-remediation patterns, observability dashboards, and credential/identity tooling that avoid long-lived access keys.

---

## The Suite

| Repository | Purpose |
|------------|---------|
| [**fedramp-terraform-library**](https://github.com/DustyStudy/fedramp-terraform-library) | Terraform modules implementing NIST 800-53 Rev5 Moderate/High controls + FedRAMP 20x KSIs |
| [**fedramp-cfn-library**](https://github.com/DustyStudy/fedramp-cfn-library) | CloudFormation counterpart of the above |
| [**aws-cloud-security-toolbox**](https://github.com/DustyStudy/aws-cloud-security-toolbox) | Practical guardrails, auto-remediation, AI/ML protections (CFN + TF) |
| [**aws-remediation-orchestrator**](https://github.com/DustyStudy/aws-remediation-orchestrator) | Security Hub-driven remediation engine: policy registry, blast-radius guardrails, human approval gate, and compliance-evidence export (Step Functions + Lambda + SSM) |
| [**aws-observability-dashboards**](https://github.com/DustyStudy/aws-observability-dashboards) | CloudWatch dashboards for security posture, Bedrock, agentic AI, NHI, EKS |
| [**aws-orgseed**](https://github.com/DustyStudy/aws-orgseed) | Multi-org account seeding via hub-and-spoke OIDC (no long-lived credentials) |
| [**aws-orgctl**](https://github.com/DustyStudy/aws-orgctl) | Ephemeral SSO / IAM Identity Center credential manager |
| [**ai-terraform-toolkit**](https://github.com/DustyStudy/ai-terraform-toolkit) | Security-hardened Terraform modules + Claude / Gemini AI workflows |
| [**aws-platform**](https://github.com/DustyStudy/aws-platform) | Self-service AWS platform on EKS: golden-path tenant onboarding, OIDC-only CI/CD, policy-as-code guardrails |
| [**azure-lighthouse-tf**](https://github.com/DustyStudy/azure-lighthouse-tf) | Terraform for Azure Lighthouse delegated management across Azure Public and Government, with GitHub Actions CI/CD |
| [**azure-baseline-tf**](https://github.com/DustyStudy/azure-baseline-tf) | Azure baseline in Terraform: Azure Policy guardrails, immutable Activity Log archive, keyless GitHub Actions auth via federated managed identities |
| [**gcp-org-baseline-tf**](https://github.com/DustyStudy/gcp-org-baseline-tf) | GCP organization baseline in Terraform: org policy guardrails, locked audit-log archive, keyless auth via Workload Identity Federation |
| [**grc-evidence-automation**](https://github.com/DustyStudy/grc-evidence-automation) | Scheduled, tamper-evident AWS/GCP control evidence mapped to SOC 2, ISO 27001, NIST 800-53 and FedRAMP 20x KSIs |
| [**ai-agent-security-toolkit**](https://github.com/DustyStudy/ai-agent-security-toolkit) | Prompt-injection fuzzer, tool-call sandbox with taint tracking, output validation and audit log for LLM agents |

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
