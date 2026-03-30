resource "aws_iam_user" "toposhare_user" {
  name = var.iam_user
}

resource "aws_iam_access_key" "toposhare_user" {
  user = aws_iam_user.toposhare_user.name
}

resource "aws_iam_group" "toposhare_access_group" {
  name = var.iam_group
}

resource "aws_iam_user_group_membership" "toposhare_access_group" {
  user = aws_iam_user.toposhare_user.name

  groups = [
    aws_iam_group.toposhare_access_group.name
  ]
}

# Minimum required policy for TopoShare functionality. See https://blog.topodot.com/1043-minimum-aws-permission-policy-for-toposhare/
data "aws_iam_policy_document" "toposhare_minimum_user_permissions" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetBucketCORS",
      "s3:ListBucket",
      "s3:PutBucketCORS",
      "s3:DeleteObject"
    ]
    resources = [
      aws_s3_bucket.toposhare_bucket.arn,
      "${aws_s3_bucket.toposhare_bucket.arn}/*",
    ]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect    = "Allow"
  }
}

resource "aws_iam_group_policy" "toposhare_minimum_user_permissions" {
  name   = var.iam_group_permission_policy_name
  group  = aws_iam_group.toposhare_access_group.name
  policy = data.aws_iam_policy_document.toposhare_minimum_user_permissions.json
}


resource "aws_s3_bucket" "toposhare_bucket" {
  bucket = "${var.bucket_name}-${random_integer.suffix.result}"
}

resource "aws_s3_bucket_ownership_controls" "toposhare_bucket" {
  bucket = aws_s3_bucket.toposhare_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "toposhare_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.toposhare_bucket]

  bucket = aws_s3_bucket.toposhare_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "toposhare_bucket" {
  bucket = aws_s3_bucket.toposhare_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

# Blocks all public access. TopoShare access is handled through signed URLs signed by the above created user.
resource "aws_s3_bucket_public_access_block" "toposhare_bucket" {
  bucket = aws_s3_bucket.toposhare_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "toposhare_bucket_config" {
  count  = var.use_default_storage_tier ? 0 : 1
  bucket = aws_s3_bucket.toposhare_bucket.bucket
  rule {
    id     = var.bucket_lifecycle_policy_name
    status = "Enabled"
    transition {
      days          = 0
      storage_class = var.storage_tier
    }
  }
}

resource "random_integer" "suffix" {
  min = 100000
  max = 100000000
}