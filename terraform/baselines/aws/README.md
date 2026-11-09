# AWS Security Services Baseline

This Terraform baseline enables account-level AWS security services that continuously produce audit and security evidence. It is intended for the Lab 5.2 AWS Security Services Baseline and uses the AWS provider in `main.tf`.

## Services and control mapping

| Service | What this baseline configures | Related controls |
|---|---|---|
| **AWS CloudTrail** | A multi-region management-events trail with global service events, S3 delivery, S3 encryption, public-access blocking, a scoped bucket policy, and log-file validation. | **AU-2** — audit events; **AU-12** — audit record generation; **AU-10** — audit information integrity through log-file validation. |
| **AWS Security Hub** | Security Hub account activation and subscriptions to NIST SP 800-53 Rev. 5 and AWS Foundational Security Best Practices standards. | **RA-5** — vulnerability and configuration assessment findings; **SI-4** — system monitoring and centralized security findings. |
| **AWS Config** *(optional)* | Not deployed by this baseline. In organization-managed accounts, Config may be centralized or blocked by an SCP. | **CM-2** — baseline configuration; **CM-6** — configuration settings; **CM-8** — system component inventory. |

## Evidence and verification

Terraform outputs expose the CloudTrail name, log bucket, and Security Hub account ID. After deployment, verify that CloudTrail is logging, Security Hub is enabled, and Security Hub findings are available. Findings may take 10–20 minutes to populate.

AWS Config is intentionally optional. If the account cannot create a recorder because of an organization policy, document that limitation rather than adding a local recorder. Security Hub may report the missing Config coverage as a finding, which is itself useful evidence.

## Cost and cleanup

CloudTrail management events are free, but Security Hub standards and AWS Config can incur charges. Destroy the lab resources when evidence collection is complete and review Security Hub subscriptions separately because ongoing checks may continue to incur cost.