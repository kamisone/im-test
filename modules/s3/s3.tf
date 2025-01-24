resource "aws_s3_bucket" "assets_bucket" {

  bucket = var.assets_bucket_name

  
  tags = {
    Environment = "Developement"
    Application = "impactes-mobile-dev"
  }

}

resource "aws_s3_bucket_acl" "assets_bucket_acl" {
  bucket     = aws_s3_bucket.assets_bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.assets_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "assets_bucket_acl_ownership" {
  bucket = aws_s3_bucket.assets_bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }

}

resource "aws_s3_bucket_public_access_block" "assets_bucket_access_block" {

  bucket                  = aws_s3_bucket.assets_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "assets_bucket_policy" {
  bucket = aws_s3_bucket.assets_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.assets_bucket.arn}/*"
      }
    ]
  })
  depends_on = [ aws_s3_bucket_public_access_block.assets_bucket_access_block ]
}

resource "aws_iam_user" "assets_bucket_iam_user" {
  name = "impactes-mobile-assets-bucket-iam-user-dev"
}

resource "aws_iam_access_key" "assets_bucket_iam_access_key" {
  user = aws_iam_user.assets_bucket_iam_user.name
}


resource "aws_iam_user_policy" "assets_bucket_iam_user_policy" {
  name = "impactes-mobile-assets-bucket-iam-user-policy-dev"
  user = aws_iam_user.assets_bucket_iam_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
        Resource = "${aws_s3_bucket.assets_bucket.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "${aws_s3_bucket.assets_bucket.arn}"
      }
    ]
  })
  depends_on = [ aws_s3_bucket_public_access_block.assets_bucket_access_block ]
}


output "assets_bucket_id" {
  value = aws_s3_bucket.assets_bucket.id
}