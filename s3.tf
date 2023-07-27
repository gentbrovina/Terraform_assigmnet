/*We define dhe S3 bucket to store data and files,
enable the versioning(as required) and server side encryption,
 read about force_destroy and encryption
*/
resource "aws_s3_bucket" "bucket" {
  bucket = "devops-directive-web-app-date"
  force_destroy = true
  versioning {
    enabled = true
  }
}
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        see_algorith = "AES256"
      }
    }
  }
 