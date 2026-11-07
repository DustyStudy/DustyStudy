# Repo security baseline

How every repo on this account gets the same security settings. This is a
personal account on GitHub Free, so there are no organization-wide rulesets
or default security configurations. Instead, three pieces cover new repos:

1. **Start from [`repo-template`](https://github.com/DustyStudy/repo-template)**,
   which carries CODEOWNERS, SECURITY.md, Dependabot config, a PR template
   and a thin CI that calls the shared workflows below.
2. **Run `scripts/repo-baseline.sh <repo>`** once after creating the repo and
   again after its first CI run. It applies the branch ruleset, Dependabot,
   secret scanning, push protection, SHA pinning and a read-only token.
3. **The weekly [baseline audit](.github/workflows/baseline-audit.yml)**
   checks every repo and opens one `baseline-drift` issue listing anything
   missed. It only reads; fixing is step 2.

## Account settings (set once, by hand)

GitHub has no API for these, so they are set in
[Settings, Code security](https://github.com/settings/security_analysis):

- Dependency graph: **Automatically enable for new repositories**
- Dependabot alerts: **Automatically enable for new repositories**
- Dependabot security updates: **Automatically enable for new repositories**
- Push protection for yourself: **Enabled** (blocks your own secret pushes to any public repo)

Also keep two-factor authentication on for the account.

## The audit token

The audit reads other repos' settings, which the built-in `GITHUB_TOKEN`
cannot do. Create a
[fine-grained token](https://github.com/settings/personal-access-tokens/new)
for **All repositories** with read-only **Actions**, **Administration**,
**Contents** and **Metadata**, then store it as the `BASELINE_AUDIT_TOKEN`
secret on this repo. Set an expiry and renew it; the audit fails loudly when it lapses.

## Opting a repo into the shared workflows

Each caller pins the workflow by commit SHA and grants only what it needs.

| Workflow | What it runs | Caller permissions |
|---|---|---|
| [`security-scan.yml`](.github/workflows/security-scan.yml) | Gitleaks, Checkov, Trivy, zizmor | `contents: read`, `security-events: write`, `actions: read` |
| [`sast.yml`](.github/workflows/sast.yml) | Semgrep (`p/default p/secrets`) | `contents: read`, `security-events: write`, `actions: read` |
| [`terraform-ci.yml`](.github/workflows/terraform-ci.yml) | `fmt -check`, `validate`, Checkov, optional read-only `plan` over OIDC. Never `apply`. | `contents: read`, plus `id-token: write` for the plan |
| [`oidc-aws.yml`](.github/workflows/oidc-aws.yml) | Assumes a role over OIDC and prints the identity | `contents: read`, `id-token: write` |

```yaml
permissions:
  contents: read

jobs:
  terraform:
    uses: DustyStudy/DustyStudy/.github/workflows/terraform-ci.yml@<sha>
    permissions:
      contents: read
      id-token: write
    with:
      working-directory: terraform
      plan-role-arn: ${{ vars.AWS_PLAN_ROLE_ARN }}
      aws-region: us-gov-west-1
```

AWS access is OIDC role assumption only. The partition comes from the role
ARN (`arn:aws` or `arn:aws-us-gov`), and a GovCloud role is rejected unless
the region is `us-gov-west-1` or `us-gov-east-1`.

## What Free does not cover

- **Private repos** can't have rulesets or branch protection, secret
  scanning, or CodeQL on GitHub Free. They still get Dependabot, the shared
  scans in CI, and Gitleaks. GitHub Pro adds branch rules for private repos.
- **Required approvals** stay at 0. With one maintainer, requiring an
  approval would block every merge, since nobody can approve their own PR.
  Pull requests, linear history, resolved threads and passing scans are
  still required.
- **Nothing applies settings at creation time.** A personal account has no
  repo-created hook, so the gap between creating a repo and running
  `repo-baseline.sh` is closed by the weekly audit.
