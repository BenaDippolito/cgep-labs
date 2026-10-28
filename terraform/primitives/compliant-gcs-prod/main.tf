# Step 5: Write the prod consumer (plan only)
# terraform/primitives/compliant-gcs-prod/main.tf  (module block; also include provider + outputs from Step 4)

provider "google" {
  project = "adept-sentinel-425907-i4"
  region  = "us-central1"
}

module "data_bucket" {
  source = "../../modules/compliant-gcs-bucket"

  gcp_project        = "adept-sentinel-425907-i4"
  project_label      = "cgep-lab"
  environment        = "prod"
  retention_days     = 365
  bucket_name_suffix = "prod-data-bad"   # use your personal suffix, e.g. prod-data-<your-initials>
}

output "attestation" { value = module.data_bucket.compliance_attestation }
output "bucket_url"  { value = module.data_bucket.bucket_url }
output "kms_key_id"  { value = module.data_bucket.kms_key_id }