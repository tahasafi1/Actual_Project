resource "aws_s3_bucket" "bucket1" {
  bucket = "GoGreens3TSSMN4ff"
  acl    = "private"

  tags = {
    Name = "GoGreenProject-Bucket"
  }
}

resource "aws_s3_bucket_lifecycle" "lifecycle" {
  bucket = aws_s3_bucket.gogreens3.bucket

  rule {
    id      = "move-to-glacier"
    prefix  = ""
    enabled = true

    transition {
      days          = 90 # Transition to Glacier after 3 months (90 days)
      storage_class = "GLACIER"
    }

    expiration {
      days = 1825 # Delete from Glacier after 5 years (1825 days)
    }
  }
}


