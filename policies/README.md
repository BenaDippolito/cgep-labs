# Policy Controls

These Rego policies enforce NIST 800-53 controls for AWS Terraform plans.

## Lab 3.3: OPA Policy Tests

OPA tests validate compliant and noncompliant cases for:

- AC-3: Access Enforcement
- SC-28: Protection of Information at Rest
- CM-6: Configuration Settings

Evidence: `evidence/lab-3-3/opa-test-results.json`

## Lab 3.4: Terraform Policy Gate

The policy gate evaluates AWS Terraform plans with Conftest and requires all three namespaces to pass:

- `compliance.sc28_aws`
- `compliance.ac3_aws`
- `compliance.cm6_aws`

The checks enforce:

- S3 server-side encryption
- S3 public access blocking with all four settings enabled
- Required tags: `Project`, `Environment`, `ManagedBy`, and `ComplianceScope`

Evidence files:

- `evidence/lab-3-4/conftest-pass.json`
- `evidence/lab-3-4/conftest-fail.json`
- `evidence/lab-3-4/conftest-results.json`

Run the policy gate with:

```bash
scripts/policy-gate.sh --workspace <terraform-workspace>