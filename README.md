<div align="center">

<!-- HEADER -->
<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=6,11,20&height=180&section=header&text=Dustin%20Arrington&fontSize=46&fontColor=fff&animation=twinkling&fontAlignY=32&desc=Senior%20Cloud%20Engineer%20%7C%20AWS%20Cloud%20Security%20%7C%20FedRAMP%20%2F%20NIST%20800-53&descAlignY=54&descSize=18" width="100%" alt="Dustin Arrington - Senior Cloud Engineer" />

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=22&pause=1000&color=58A6FF&center=true&vCenter=true&random=false&width=640&lines=FedRAMP+Rev5+%2B+20x+as+code;NIST+800-53+controls+in+Terraform+%26+CloudFormation;Zero+long-lived+credentials;Multi-account+AWS+governance;Securing+LLM+agents)](https://github.com/DustyStudy)

<br/>

<a href="https://github.com/DustyStudy?tab=followers"><img src="https://img.shields.io/github/followers/DustyStudy?label=Followers&style=for-the-badge&logo=github&logoColor=white&labelColor=1a1b27&color=58a6ff" alt="followers" /></a>
<img src="https://img.shields.io/github/stars/DustyStudy?label=Total%20Stars&style=for-the-badge&logo=github&logoColor=white&labelColor=1a1b27&color=58a6ff" alt="stars" />
<img src="https://komarev.com/ghpvc/?username=DustyStudy&style=for-the-badge&color=blueviolet&labelColor=1a1b27" alt="profile views" />

<br/><br/>

<a href="https://www.linkedin.com/in/dustyarrington/"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn" /></a>

</div>

<br/>

## About Me

```python
class DustinArrington:
    def __init__(self):
        self.role = "Senior Cloud Engineer"
        self.focus = "AWS cloud security & compliance automation"
        self.clouds = ["AWS (commercial + GovCloud)", "Azure (Public + Government)", "GCP"]
        self.frameworks = ["FedRAMP Rev5", "FedRAMP 20x KSIs", "NIST 800-53 Rev5",
                           "SOC 2", "ISO 27001:2022"]

    @property
    def principles(self):
        return [
            "Short-lived credentials only (OIDC / SSO)",
            "Honest coverage-gap documentation",
            "Partition-aware by default",
            "Every repo scanned in CI (Checkov, Trivy, Gitleaks, tflint)",
        ]
```

---

<div align="center">

## Contribution Graph

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/DustyStudy/DustyStudy/output/snake-dark.svg" />
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/DustyStudy/DustyStudy/output/snake.svg" />
  <img alt="contribution snake" src="https://raw.githubusercontent.com/DustyStudy/DustyStudy/output/snake-dark.svg" />
</picture>

</div>

---

## The Suite

<div align="center">

### FedRAMP & Compliance

| | Repository | Purpose |
|:--:|------------|---------|
| :shield: | [**fedramp-terraform-library**](https://github.com/DustyStudy/fedramp-terraform-library) | Terraform modules implementing NIST 800-53 Rev5 Moderate/High controls + FedRAMP 20x KSIs |
| :building_construction: | [**fedramp-cfn-library**](https://github.com/DustyStudy/fedramp-cfn-library) | CloudFormation counterpart of the above |
| :robot: | [**fedramp-cloud-compliance-skill**](https://github.com/DustyStudy/fedramp-cloud-compliance-skill) | Agent Skill for Claude Code: FedRAMP 2026 Consolidated Rules (Rev5 + 20x) on AWS, Azure, GCP |
| :receipt: | [**grc-evidence-automation**](https://github.com/DustyStudy/grc-evidence-automation) | Scheduled, tamper-evident AWS/GCP control evidence mapped to SOC 2, ISO 27001, NIST 800-53, FedRAMP 20x |

### AWS Security & Governance

| | Repository | Purpose |
|:--:|------------|---------|
| :toolbox: | [**aws-cloud-security-toolbox**](https://github.com/DustyStudy/aws-cloud-security-toolbox) | Practical guardrails, auto-remediation, AI/ML protections (CFN + TF) |
| :rotating_light: | [**aws-remediation-orchestrator**](https://github.com/DustyStudy/aws-remediation-orchestrator) | Security Hub-driven remediation: policy registry, blast-radius guardrails, human approval gate |
| :mag: | [**prowler-aws-template**](https://github.com/DustyStudy/prowler-aws-template) | Org-wide Prowler scans for under $1/month: GitHub Actions + OIDC, StackSet read-only roles, emailed HTML reports |
| :bar_chart: | [**aws-observability-dashboards**](https://github.com/DustyStudy/aws-observability-dashboards) | CloudWatch dashboards for security posture, Bedrock, agentic AI, NHI, EKS |
| :seedling: | [**aws-orgseed**](https://github.com/DustyStudy/aws-orgseed) | Multi-org account seeding via hub-and-spoke OIDC (no long-lived credentials) |
| :key: | [**aws-orgctl**](https://github.com/DustyStudy/aws-orgctl) | Ephemeral SSO / IAM Identity Center credential manager |
| :ship: | [**aws-platform**](https://github.com/DustyStudy/aws-platform) | Self-service AWS platform on EKS: golden-path onboarding, OIDC-only CI/CD, policy-as-code |
| :jigsaw: | [**ai-terraform-toolkit**](https://github.com/DustyStudy/ai-terraform-toolkit) | Security-hardened Terraform modules + Claude / Gemini AI workflows |

### Multi-Cloud Baselines

| | Repository | Purpose |
|:--:|------------|---------|
| :large_blue_diamond: | [**azure-lighthouse-tf**](https://github.com/DustyStudy/azure-lighthouse-tf) | Azure Lighthouse delegated management across Azure Public and Government |
| :small_blue_diamond: | [**azure-baseline-tf**](https://github.com/DustyStudy/azure-baseline-tf) | Azure Policy guardrails, immutable Activity Log archive, keyless GitHub Actions auth |
| :cloud: | [**gcp-org-baseline-tf**](https://github.com/DustyStudy/gcp-org-baseline-tf) | GCP org policy guardrails, locked audit-log archive, Workload Identity Federation |

### AI Agent Security

| | Repository | Purpose |
|:--:|------------|---------|
| :test_tube: | [**ai-agent-security-toolkit**](https://github.com/DustyStudy/ai-agent-security-toolkit) | Prompt-injection fuzzer, tool-call sandbox with taint tracking, output validation, audit log |

### Tooling

| | Repository | Purpose |
|:--:|------------|---------|
| :computer: | [**workstation-bootstrap**](https://github.com/DustyStudy/workstation-bootstrap) | Workstation bootstrap (Windows / macOS / WSL2) for Terraform and AWS tooling, with automated tool-version pin checks |

</div>

---

## Tech Stack

<div align="center">

### Cloud

![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonwebservices&logoColor=white)
![GovCloud](https://img.shields.io/badge/AWS%20GovCloud-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![GCP](https://img.shields.io/badge/Google%20Cloud-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)
![Kubernetes](https://img.shields.io/badge/EKS-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)

### Infrastructure as Code

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![CloudFormation](https://img.shields.io/badge/CloudFormation-FF4F8B?style=for-the-badge&logo=amazonwebservices&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)

### Languages

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![HCL](https://img.shields.io/badge/HCL-844FBA?style=for-the-badge&logo=hashicorp&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

### Security Tooling

![Checkov](https://img.shields.io/badge/Checkov-5C4EE5?style=for-the-badge&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?style=for-the-badge&logo=trivy&logoColor=white)
![Gitleaks](https://img.shields.io/badge/Gitleaks-DC382D?style=for-the-badge&logoColor=white)
![Prowler](https://img.shields.io/badge/Prowler-1F2937?style=for-the-badge&logoColor=white)
![Security Hub](https://img.shields.io/badge/Security%20Hub-DD344C?style=for-the-badge&logo=amazonwebservices&logoColor=white)
![Bedrock](https://img.shields.io/badge/Bedrock-01A88D?style=for-the-badge&logo=amazonwebservices&logoColor=white)

</div>

---

## GitHub Stats

<div align="center">

<img width="49%" src="https://streak-stats.demolab.com/?user=DustyStudy&theme=tokyonight&hide_border=true&background=0D1117&stroke=58a6ff&ring=58a6ff&fire=58a6ff&currStreakLabel=58a6ff" alt="streak stats" />
<img width="49%" src="https://github-readme-stats.vercel.app/api?username=DustyStudy&show_icons=true&theme=tokyonight&hide_border=true&bg_color=0D1117&title_color=58a6ff&icon_color=58a6ff&text_color=c9d1d9" alt="GitHub stats" />

<img width="100%" src="https://github-readme-activity-graph.vercel.app/graph?username=DustyStudy&bg_color=0D1117&color=58a6ff&line=58a6ff&point=58a6ff&area=true&hide_border=true" alt="activity graph" />

</div>

<details>
<summary><b>More Stats</b></summary>
<div align="center">

<img src="https://github-profile-summary-cards.vercel.app/api/cards/profile-details?username=DustyStudy&theme=github_dark" alt="profile details" />

<img src="https://github-profile-summary-cards.vercel.app/api/cards/repos-per-language?username=DustyStudy&theme=github_dark" alt="repos per language" />
<img src="https://github-profile-summary-cards.vercel.app/api/cards/most-commit-language?username=DustyStudy&theme=github_dark" alt="most commit language" />

</div>
</details>

---

## GitHub Trophies

<div align="center">

[![trophy](https://github-profile-trophy.vercel.app/?username=DustyStudy&theme=onestar&no-frame=true&no-bg=true&column=7&margin-w=15)](https://github.com/ryo-ma/github-profile-trophy)

</div>

---

## Focus Areas

- FedRAMP Moderate / High / 20x baselines
- Multi-account AWS Organizations governance
- AI/ML (Bedrock, SageMaker, agentic workloads) security
- Continuous monitoring & observability
- Zero long-lived credentials patterns

---

<!-- FOOTER -->
<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=6,11,20&height=100&section=footer" width="100%" alt="" />

**Dustin Arrington** | Senior Cloud Engineer | AWS Cloud Security | FedRAMP / NIST 800-53 | Multi-Account Governance | Open Source

</div>
