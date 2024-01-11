resource "aws_s3_bucket" "bucket1" {
  bucket = "GoGreens3TSSMN4ff"
  acl    = "private"

  tags = {
    Name = "GoGreenProject-Bucket"
  }
}

# resource "aws_s3_bucket_lifecycle" "lifecycle" {
#   bucket = aws_s3_bucket.bucket1.id

#   rule {
#     id      = "move-to-glacier"
#     prefix  = ""
#     enabled = true

#     transition {
#       days          = 90 
#       storage_class = "GLACIER"
#     }

#     expiration {
#       days = 1825 
#     }
#   }
# }


