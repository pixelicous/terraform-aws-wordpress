# Data source to get the Account ID of the AWS Elastic Load Balancing Service Account - 
# in a given region for the purpose of whitelisting in S3 bucket policy.
data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  acl           = "private"
  bucket        = "${var.s3_bucket_name}"
  force_destroy = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "wordpress-buck-policy",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*",
      "Principal": {
        "AWS": [
           "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY

  region = "${var.region}"

  tags = "${var.tags}"
}