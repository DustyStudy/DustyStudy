# Dustin Arrington

**Senior Cloud Engineer** focused on AWS multi-account governance and compliance-as-code: FedRAMP (Rev5 and 20x) and NIST 800-53 controls implemented as code on AWS, in both commercial regions and GovCloud.

I build multi-account guardrails, audit evidence pipelines, and remediation workflows that run on short-lived credentials only (OIDC and IAM Identity Center, zero long-lived keys). Every repo below has automated tests (terraform test, pytest) and is scanned in CI with Checkov, Trivy, and Gitleaks. Each one documents its coverage gaps rather than hiding them. I use AI coding assistants (Claude Code) for drafting and review. I design each system, and I verify it with tests and, where noted, live deployments.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/dustyarrington/)

## Start here

- [**fedramp-terraform-library**](https://github.com/DustyStudy/fedramp-terraform-library): NIST 800-53 Rev5 and FedRAMP 20x controls as Terraform modules, with plan-time tests that check the rendered IAM and bucket policies.
- [**aws-remediation-orchestrator**](https://github.com/DustyStudy/aws-remediation-orchestrator): Security Hub findings routed through policy, blast-radius limits and a human approval gate. [Tested against a real AWS account](https://github.com/DustyStudy/aws-remediation-orchestrator/blob/main/docs/PROOF.md).
- [**grc-evidence-automation**](https://github.com/DustyStudy/grc-evidence-automation): scheduled, tamper-evident control evidence for SOC 2, ISO 27001, NIST 800-53 and FedRAMP 20x. [Deployed and verified in a live account](https://github.com/DustyStudy/grc-evidence-automation/blob/main/docs/live-deployment-verification.md).
- [**aws-org-guardrails**](https://github.com/DustyStudy/aws-org-guardrails): SCPs, a permissions boundary and Identity Center permission sets for AWS Organizations, tested as policy behavior against the JSON Terraform renders.
- [**aws-sso-broker**](https://github.com/DustyStudy/aws-sso-broker): short-lived IAM Identity Center credentials across many accounts, with no long-lived access keys. [Tested against a real Identity Center instance](https://github.com/DustyStudy/aws-sso-broker/blob/main/docs/PROOF.md).

## Threat-informed hardening

Gaps I found in my own tooling after reviewing AWS attack techniques in active use, and the change that closed each one. Full log, with sources: [THREAT-RESPONSE.md](THREAT-RESPONSE.md).

- **Stolen instance-role credentials:** the remediation orchestrator could disable IAM user keys but not revoke role sessions. Added `RevokeRoleSessions` in [aws-remediation-orchestrator v1.1.0](https://github.com/DustyStudy/aws-remediation-orchestrator/releases/tag/v1.1.0). Seen in the wild: [Cisco Talos, 2026](https://blog.talosintelligence.com/uat-10608-inside-a-large-scale-automated-credential-harvesting-operation-targeting-web-applications/).
- **Escalation through one IAM action:** the Identity Center auditor missed permission sets granting `iam:PutRolePolicy` or `sso:CreateAccountAssignment` on `*`. Added in [fedramp-terraform-library v1.2.0](https://github.com/DustyStudy/fedramp-terraform-library/releases/tag/v1.2.0). Seen in the wild: [Sysdig, 2026](https://www.sysdig.com/blog/ai-assisted-cloud-intrusion-achieves-admin-access-in-8-minutes).
- **Internet-exposed databases:** the open-ingress playbook only closed SSH and RDP. It now also closes database ports in [aws-remediation-orchestrator v1.1.0](https://github.com/DustyStudy/aws-remediation-orchestrator/releases/tag/v1.1.0). Seen in the wild: [Wiz, 2025](https://www.wiz.io/blog/postgresql-cryptomining).

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
| [**aws-org-guardrails**](https://github.com/DustyStudy/aws-org-guardrails) | Organization guardrails: SCP bundles, a permissions boundary against privilege escalation, and Identity Center permission sets that require it. Commercial and GovCloud |
| [**aws-remediation-orchestrator**](https://github.com/DustyStudy/aws-remediation-orchestrator) | Security Hub-driven remediation with a policy registry, blast-radius guardrails, and a human approval gate. Six playbooks (S3 exposure, open SSH/RDP and database ports, compromised and stale keys, role session revocation, instance isolation) and optional Wiz intake |
| [**prowler-aws-template**](https://github.com/DustyStudy/prowler-aws-template) | Org-wide Prowler scans for under $1/month: GitHub Actions, OIDC, StackSet read-only roles, emailed reports |
| [**aws-sso-broker**](https://github.com/DustyStudy/aws-sso-broker) | CLI for ephemeral IAM Identity Center credentials across many accounts: PKCE sign-in, guardrails for protected accounts, and an audit log that joins to CloudTrail |

### AI security

| Repository | What it does |
|------------|--------------|
| [**aws-ai-guardrails**](https://github.com/DustyStudy/aws-ai-guardrails) | Terraform guardrails for Bedrock and SageMaker: SCPs, agent IAM audits, invocation-logging enforcement, cost controls |
| [**ai-agent-security-toolkit**](https://github.com/DustyStudy/ai-agent-security-toolkit) | Prompt-injection fuzzer, tool-call sandbox with taint tracking, output validation, tamper-evident audit log |

## Tools and platforms

**Cloud:** AWS (including GovCloud)<br>
**Infrastructure as code:** Terraform, GitHub Actions<br>
**Languages:** Python, HCL, PowerShell, Bash<br>
**Security tooling:** Checkov, Trivy, Gitleaks, Prowler, Security Hub, GuardDuty, AWS Config<br>
**Frameworks:** FedRAMP Rev5 and 20x, NIST 800-53 Rev5, SOC 2, ISO 27001:2022
