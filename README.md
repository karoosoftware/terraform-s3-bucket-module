# AWS S3 Bucket Module

This module creates a single AWS S3 bucket with configurable versioning, public access block settings, default server-side encryption, and optional bucket policy, CORS, and Lambda notification configuration.

## What This Module Creates

- 1 S3 bucket
- S3 bucket versioning configuration
- S3 public access block configuration
- Default server-side encryption
- Optional bucket policy
- Optional CORS configuration
- Optional S3 to Lambda notification

## Usage

```hcl
module "bucket" {
  source = "git::ssh://git@github.com:karoosoftware/terraform-s3-bucket-module.git?ref=<commit-sha>"

  bucket_name = "margana-results-prod"
  tags = {
    Environment = "prod"
    Service     = "results"
  }

  versioning_enabled = true
  sse_algorithm      = "AES256"

  enable_cors     = true
  allowed_origins = ["https://app.example.com"]
  allowed_methods = ["GET", "HEAD", "OPTIONS"]

  notification_lambda_arn    = "arn:aws:lambda:eu-west-2:123456789012:function:process-results"
  notification_filter_suffix = ".json"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `bucket_name` | Name of your S3 bucket | `string` | n/a | yes |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |
| `versioning_enabled` | Enable bucket versioning | `bool` | `true` | no |
| `sse_algorithm` | Server-side encryption algorithm | `string` | `"AES256"` | no |
| `enable_cors` | Whether to create a CORS configuration | `bool` | `false` | no |
| `allowed_origins` | Allowed origins for CORS | `list(string)` | `[]` | no |
| `allowed_methods` | Allowed methods for CORS | `list(string)` | `["GET", "HEAD", "OPTIONS"]` | no |
| `allowed_headers` | Allowed headers for CORS | `list(string)` | `["*"]` | no |
| `expose_headers` | Headers exposed by CORS | `list(string)` | `[]` | no |
| `max_age_seconds` | CORS preflight cache duration | `number` | `3000` | no |
| `notification_lambda_arn` | Optional Lambda ARN to invoke from S3 notifications | `string` | `null` | no |
| `notification_events` | S3 events that trigger the Lambda notification | `list(string)` | `["s3:ObjectCreated:Put"]` | no |
| `notification_filter_prefix` | Optional object key prefix filter | `string` | `null` | no |
| `notification_filter_suffix` | Optional object key suffix filter | `string` | `null` | no |
| `block_public_acls` | Whether Amazon S3 should block public ACLs for this bucket | `bool` | `true` | no |
| `block_public_policy` | Whether Amazon S3 should block public bucket policies for this bucket | `bool` | `true` | no |
| `ignore_public_acls` | Whether Amazon S3 should ignore public ACLs for this bucket | `bool` | `true` | no |
| `restrict_public_buckets` | Whether Amazon S3 should restrict public bucket policies for this bucket | `bool` | `true` | no |
| `bucket_policy` | Optional bucket policy JSON | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | ID of the S3 bucket |
| `bucket_arn` | ARN of the S3 bucket |
| `bucket_name` | Name of the S3 bucket |
| `bucket_regional_domain_name` | Regional domain name of the S3 bucket |

## Notes

- Versioning is controlled by `versioning_enabled`.
- Encryption is controlled by `sse_algorithm`.
- A bucket policy is only created when `bucket_policy` is set.
- CORS is only created when `enable_cors = true`.
- Lambda notification resources are only created when `notification_lambda_arn` is set.

## Release Process

- Open a pull request and let the Terraform validation workflow pass.
- Merge the change to `main`.
- Create and push a version tag, for example:

```bash
git tag v1.0.0
git push origin v1.0.0
```

- Pushing the tag triggers the release workflow and creates the GitHub release.
- Consume released versions from other Terraform repos by pinning the module source with `?ref=v1.0.0`.

## Prerequisites

- Terraform 1.x
- AWS provider configured in the root module
- IAM permissions to create S3 buckets, bucket policies, bucket notifications, and Lambda permissions
