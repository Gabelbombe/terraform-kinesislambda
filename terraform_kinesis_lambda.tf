#<><> Provider <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> #
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

#<><> IAM Role <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> #
resource "aws_iam_role" "iam_for_terraform_lambda" {
  name = "kinesis_streamer_${var.env}_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

#<><> IAM Role Policies <><><><><><><><><><><><><><><><><><><><><><><><><><><><>#
resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_basic_execution" {
  role       = "${aws_iam_role.iam_for_terraform_lambda.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_kinesis_execution" {
  role       = "${aws_iam_role.iam_for_terraform_lambda.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

#<><> Lambda Function <><><><><><><><><><><><><><><><><><><><><><><><><><><><><>#
resource "aws_lambda_function" "terraform_kinesis_streamer_func" {
  filename         = "payload.zip"
  function_name    = "kinesis_streamer_${var.env}_demo_lambda_function"
  role             = "${aws_iam_role.iam_for_terraform_lambda.arn}"
  handler          = "lib/handler.demoHandler"
  runtime          = "python2.7"
  source_code_hash = "${base64sha256(file("payload.zip"))}"
}

resource "aws_lambda_event_source_mapping" "kinesis_lambda_event_mapping" {
  batch_size        = 100
  event_source_arn  = "${aws_kinesis_stream.kinesis_streamer_demo_stream.arn}"
  enabled           = true
  function_name     = "${aws_lambda_function.terraform_kinesis_streamer_func.arn}"
  starting_position = "TRIM_HORIZON"
}

#<><> Kinesis Streams <><><><><><><><><><><><><><><><><><><><><><><><><><><><><>#
resource "aws_kinesis_stream" "kinesis_streamer_demo_stream" {
  name             = "terraform-kinesis-streamer-demo-stream"
  shard_count      = 1                                        ## Only single shard needed for demo
  retention_period = 24                                       ## Retention up to 7 days, https://aws.amazon.com/about-aws/whats-new/2015/10/amazon-kinesis-extended-data-retention/

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags {
    Environment = "terraform-kinesis-streamer-${var.env}-test" ## Vars file will hold envinfo later
  }
}
