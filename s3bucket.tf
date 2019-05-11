# Data source to get the Account ID of the AWS Elastic Load Balancing Service Account - 
# in a given region for the purpose of whitelisting in S3 bucket policy.
data "aws_elb_service_account" "main" {}

# --------------------------------------------------------

# WordPress content S3 bucket IAM role, policy and profile
# Attached to EC2 instances
resource "aws_iam_instance_profile" "wordpress" {
  name = "WordPressS3Profile"
  role = "${aws_iam_role.wordpress.name}"
}

resource "aws_iam_role" "wordpress" {
  name = "WordPressS3Role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]

}
EOF

  tags = "${var.tags}"
}

resource "aws_iam_role_policy" "wordpress" {
  name = "WordPressS3Policy"
  role = "${aws_iam_role.wordpress.id}"

  policy = <<EOF
{
	"Version": "2012-10-17",
	
	"Statement": [
	{
		"Effect": "Allow",
		"Action": [
			"s3:CreateBucket",
			"s3:DeleteObject",
			"s3:Put*",
			"s3:Get*",
			"s3:List*"
		],
		"Resource": [
			"${aws_s3_bucket.wordpress.arn}",
			"${aws_s3_bucket.wordpress.arn}/*"
		]
	}
	]
}
EOF
}

# --------------------------------------------------------
# S3 Buckets

resource "aws_s3_bucket" "wordpress" {
  acl           = "private"
  bucket        = "${var.s3_bucket_name}"
  force_destroy = true

  region = "${var.region}"

  tags = "${var.tags}"
}

resource "aws_s3_bucket" "elb_logs" {
  acl           = "private"
  bucket        = "${var.s3_elblogs_bucket_name}"
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
      "Resource": "arn:aws:s3:::${var.s3_elblogs_bucket_name}/*",
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
