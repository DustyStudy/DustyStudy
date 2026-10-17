# Engineering notes: governing cloud changes

These projects explore one operating model: prevent avoidable changes, use
short-lived access, detect drift, govern remediation, and retain evidence of
what happened. The repository diagram shows the intended integration; the
evidence below identifies the components exercised in live AWS accounts.

## A finding's path through the system

Consider an exposed resource reported to Security Hub. The remediation
orchestrator normalizes the finding, selects a policy, checks the circuit
breaker and resource exemptions, then either records a no-op or runs an SSM
playbook. Disruptive actions require approval. The ledger records the
decision and the scheduled exporter produces evidence for downstream review.

The policy lives outside the playbook so an operator can change the response
mode without editing remediation code. Dedicated member-account roles limit
where a playbook can act. The circuit breaker gives the operator a single
way to stop new actions during an incident.

[Pipeline and live playbook evidence](https://github.com/DustyStudy/aws-remediation-orchestrator/blob/ff52fb396a076e894835d376ad2ecf95e68b5585/docs/PROOF.md)
covers six playbooks, approval denial, timeout and cross-account execution.
These are historical results for that revision, not proof of every later change.

## What the live runs establish

| System | Recorded result | Scope of the run |
|---|---|---|
| [Terraform controls](https://github.com/DustyStudy/fedramp-terraform-library/blob/a930ed3042eed2a1c96699e5a481fff8a401274e/docs/LIVE-PROOF.md) | Thirteen modules deployed and probed in a four-account organization, including database, registry and web ACL data paths | The report identifies the exercised modules; it does not establish an authorization or prove every module |
| [Remediation](https://github.com/DustyStudy/aws-remediation-orchestrator/blob/ff52fb396a076e894835d376ad2ecf95e68b5585/docs/PROOF.md) | Six playbooks changed real resources across the recorded runs; denial and timeout prevented changes | Sandbox verification, not a production availability or throughput claim |
| [Evidence collection](https://github.com/DustyStudy/grc-evidence-automation/blob/9237efad37af3a77ccc96344aaccceea942e7b57/docs/live-deployment-verification.md) | Thirteen AWS collectors produced records plus a manifest; S3/KMS delivery and downloaded evidence verification were exercised | Same-account run; cross-account assumption, GCP, vendor ingestion and unattended scheduling were outside that run |
| [Identity broker](https://github.com/DustyStudy/aws-sso-broker/blob/9e4e9336a2b0b4de90faa89b06e61407a3626efb/docs/PROOF.md) | Live Identity Center sign-in, credential use, logout and hardening checks | Local guardrails supplement IAM and SCPs; they do not enforce a server-side security boundary |

The collector and remediation exporter share related evidence formats. Each
report covers its own system; an end-to-end run across every project,
including downstream ingestion, is the next proof to record.

## Decisions exposed by deployment

The remediation runs found IAM resource-ARN mismatches and a DynamoDB
attribute-type error (Terraform coerced a `NULL` marker to the string
`"true"`) that static checks and unit tests had missed. The fix needed to
match the service's authorization and type behavior, then be verified at the
actual API boundary.

The evidence collector's first deployment hit a sandbox Lambda concurrency
quota. Making the reservation configurable preserved the production default
while allowing low-quota accounts to run the same module.

The identity broker's second live run caught session behavior that would have
forced hourly sign-in. That is an operational defect even when credentials
remain short-lived and individual API calls succeed.

## Cost and operating limits

[Prowler's cost model](https://github.com/DustyStudy/prowler-aws-template/blob/main/docs/COST.md)
makes account count, region count, scan frequency and report retention explicit.
Those assumptions matter more than an unconditional low-cost claim.

For the orchestration and evidence projects, the next measurements to record
are end-to-end latency, collection duration, throttling behavior and observed
cost at stated account and resource counts, so performance claims stay tied to
measured runs.
