variable "bucket_name" {
  type = string
  description = "Name of your S3 bucket"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable bucket versioning."
  default     = true
}

variable "sse_algorithm" {
  type        = string
  description = "Server-side encryption algorithm."
  default     = "AES256"
}

variable "allowed_origins" {
  type        = list(string)
  description = "Allowed origins for CORS."
  default     = []
}

variable "allowed_methods" {
  type        = list(string)
  description = "Allowed methods for CORS."
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "allowed_headers" {
  type        = list(string)
  description = "Allowed headers for CORS."
  default     = ["*"]
}

variable "expose_headers" {
  type        = list(string)
  description = "Headers exposed by CORS."
  default     = []
}

variable "max_age_seconds" {
  type        = number
  description = "CORS preflight cache duration."
  default     = 3000
}

variable "notification_events" {
  type        = list(string)
  description = "S3 events that trigger the Lambda notification."
  default     = ["s3:ObjectCreated:Put"]
}

variable "notification_lambda_arn" {
  type        = string
  description = "Optional Lambda ARN to invoke from S3 notifications."
  default     = null
}

variable "notification_filter_prefix" {
  type        = string
  description = "Optional object key prefix filter."
  default     = null
}

variable "notification_filter_suffix" {
  type        = string
  description = "Optional object key suffix filter."
  default     = null
}

variable "enable_cors" {
  type        = bool
  description = "Whether to create a CORS configuration."
  default     = false
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "bucket_policy" {
  type        = string
  description = "Optional bucket policy JSON."
  default     = null
}