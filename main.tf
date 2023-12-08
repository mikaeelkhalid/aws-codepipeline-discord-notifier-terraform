# installs NPM packages on every run for lambda function 
resource "null_resource" "install_lambda_function_packages" {
  triggers = {
    force_run = uuid()
  }
  provisioner "local-exec" {
    command = "cd ${path.module}/aws-codepipeline-discord-lambda && npm install"
  }
}

# zip lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/aws-codepipeline-discord-lambda"
  output_path = "${path.module}/tmp/aws-codepipeline-discord-lambda.zip"

  depends_on = [null_resource.install_lambda_function_packages]
}

# iam role for lambda function
resource "aws_iam_role" "lambda_role" {
  name = "${var.APP_NAME}-codepipeline-discord-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}