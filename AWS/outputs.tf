output "bucket_name" {
  value = aws_s3_bucket.toposhare_bucket.id
}
output "region" {
  value = aws_s3_bucket.toposhare_bucket.bucket_region
}
output "access_key" {
  value = aws_iam_access_key.toposhare_user.id
}
output "secret_key" {
  value     = aws_iam_access_key.toposhare_user.secret
  sensitive = true
}