# Create bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Enable versioning
resource "aws_s3_bucket_versioning" "bucket_version" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.bucket_policy != null ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  policy = var.bucket_policy
}

# Default server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_origins = var.allowed_origins
    allowed_methods = var.allowed_methods
    allowed_headers = var.allowed_headers
    expose_headers  = var.expose_headers
    max_age_seconds = var.max_age_seconds
  }
}

resource "aws_s3_bucket_notification" "this" {
  count  = var.notification_lambda_arn != null ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = var.notification_lambda_arn
    events              = var.notification_events
    filter_prefix       = var.notification_filter_prefix
    filter_suffix       = var.notification_filter_suffix
  }

  depends_on = [aws_lambda_permission.this]
}

resource "aws_lambda_permission" "this" {
  count         = var.notification_lambda_arn != null ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.notification_lambda_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}