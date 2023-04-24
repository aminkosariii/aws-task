resource "aws_s3_bucket" "test-bucket"{
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "test-bucket_access" {
  bucket = aws_s3_bucket.test-bucket.id
  policy = data.aws_iam_policy_document.test-bucket_policy.json
}

data "aws_iam_policy_document" "test-bucket_policy" {
  statement {
    principals {
	  type = "*"
	  identifiers = ["*"]
	}

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.test-bucket.arn,
      "${aws_s3_bucket.test-bucket.arn}/*",
    ]
  }
}
# versioning public s3
resource "aws_s3_bucket_acl" "test-bucket_acl" {
  bucket = aws_s3_bucket.test-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "test-bucket_versioning" {
  bucket = aws_s3_bucket.test-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


# server side encryption 
resource "aws_kms_key" "s3enc" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 20
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3SSE" {
  bucket = aws_s3_bucket.test-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3enc.arn
      sse_algorithm     = "aws:kms"
    }
  }
}