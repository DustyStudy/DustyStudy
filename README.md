# Dustin Arrington

**Cloud Engineer** focused on cloud security and compliance automation: FedRAMP (Rev5 and 20x) and NIST 800-53 controls implemented as code on AWS, in both commercial regions and GovCloud.

I build multi-account guardrails, audit evidence pipelines, and remediation workflows that run on short-lived credentials only (OIDC and SSO, no long-lived keys). Every repo below has automated tests (`terraform test`, pytest) and is scanned in CI with Checkov, Trivy, and Gitleaks. Each one documents its coverage gaps rather than hiding them. I use AI coding assistants (Claude Code) for drafting and review. I design each system, and I verify it with tests and, where noted, live deployments.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/dustyarrington/)

## Start here

- [**fedramp-terraform-library**](https://github.com/DustyStudy/fedramp-terraform-library): NIST 800-53 Rev5 and FedRAMP 20x controls as Terraform modules, with plan-time tests that check the rendered IAM and bucket policies.
- [**aws-remediation-orchestrator**](https://github.com/DustyStudy/aws-remediation-orchestrator): Security Hub findings routed through policy, blast-radius limits and a human approval gate. [Tested against a real AWS account](https://github.com/DustyStudy/aws-remediation-orchestrator/blob/main/docs/PROOF.md).
- [**grc-evidence-automation**](https://github.com/DustyStudy/grc-evidence-automation): scheduled, tamper-evident control evidence for SOC 2, ISO 27001, NIST 800-53 and FedRAMP 20x. [Deployed and verified in a live account](https://github.com/DustyStudy/grc-evidence-automation/blob/main/docs/live-deployment-verification.md).
- [**aws-sso-broker**](https://github.com/DustyStudy/aws-sso-broker): short-lived IAM Identity Center credentials across many accounts, with no long-lived access keys.

## Projects

### FedRAMP and compliance

| Repository | What it does |
|------------|--------------|
| [**fedramp-terraform-library**](https://github.com/DustyStudy/fedramp-terraform-library) | Terraform modules implementing NIST 800-53 Rev5 Moderate/High controls and FedRAMP 20x KSIs |
| [**grc-evidence-automation**](https://github.com/DustyStudy/grc-evidence-automation) | Scheduled, tamper-evident AWS/GCP control evidence mapped to SOC 2, ISO 27001, NIST 800-53, and FedRAMP 20x |
| [**fedramp-cloud-compliance-skill**](https://github.com/DustyStudy/fedramp-cloud-compliance-skill) | Claude Code Agent Skill for the FedRAMP 2026 Consolidated Rules (Rev5 and 20x) on AWS, Azure, and GCP |

### AWS security and governance

| Repository | What it does |
|------------|--------------|
| [**aws-remediation-orchestrator**](https://github.com/DustyStudy/aws-remediation-orchestrator) | Security Hub-driven remediation with a policy registry, blast-radius guardrails, and a human approval gate. Five playbooks (S3 exposure, open SSH/RDP, compromised and stale keys, instance isolation) and optional Wiz intake |
| [**prowler-aws-template**](https://github.com/DustyStudy/prowler-aws-template) | Org-wide Prowler scans for under $1/month: GitHub Actions, OIDC, StackSet read-only roles, emailed reports |
| [**aws-sso-broker**](https://github.com/DustyStudy/aws-sso-broker) | CLI for ephemeral IAM Identity Center credentials across many accounts |
| [**aws-platform**](https://github.com/DustyStudy/aws-platform) | Self-service EKS platform: golden-path tenant onboarding, OIDC-only CI/CD, policy as code |

### AI security

| Repository | What it does |
|------------|--------------|
| [**aws-ai-guardrails**](https://github.com/DustyStudy/aws-ai-guardrails) | Terraform guardrails for Bedrock and SageMaker: SCPs, agent IAM audits, invocation-logging enforcement, cost controls |
| [**ai-agent-security-toolkit**](https://github.com/DustyStudy/ai-agent-security-toolkit) | Prompt-injection fuzzer, tool-call sandbox with taint tracking, output validation, tamper-evident audit log |

## Tools and platforms

**Cloud:** AWS (including GovCloud), EKS<br>
**Infrastructure as code:** Terraform, GitHub Actions<br>
**Languages:** Python, HCL, PowerShell, Bash<br>
**Security tooling:** Checkov, Trivy, Gitleaks, Prowler, Security Hub, GuardDuty, AWS Config<br>
**Frameworks:** FedRAMP Rev5 and 20x, NIST 800-53 Rev5, SOC 2, ISO 27001:2022
