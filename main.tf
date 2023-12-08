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

# iam policy for lambda function
resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "${var.APP_NAME}-discord-codepipeline-lambda-role-policy"
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [{
      "Sid": "WriteLogsToCloudWatch",
      "Effect" : "Allow",
      "Action" : [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource" : "arn:aws:logs:*:*:*"
    }, {
      "Sid": "AllowAccesstoPipeline",
      "Effect" : "Allow",
      "Action" : [
        "codepipeline:GetPipeline",
        "codepipeline:GetPipelineState",
        "codepipeline:GetPipelineExecution",
        "codepipeline:ListPipelineExecutions",
        "codepipeline:ListActionTypes",
        "codepipeline:ListPipelines"
      ],
      "Resource" : "*"
    }
  ]
}
EOF
}

# lambda function
resource "aws_lambda_function" "lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  description      = "Posts a message to Discord channel '${var.DISCORD_CHANNEL}' every time there is an update to codepipeline execution."
  function_name    = "${var.APP_NAME}-discord-codepipeline-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.handle"
  runtime          = "nodejs14.x"
  timeout          = var.LAMBDA_TIMEOUT
  memory_size      = var.LAMBDA_MEMORY_SIZE

  environment {
    variables = {
      "DISCORD_WEBHOOK_URL" = var.DISCORD_WEBHOOK_URL
      "DISCORD_CHANNEL"       = var.DISCORD_CHANNEL
      "RELEVANT_STAGES"     = var.RELEVANT_STAGES
      "REGION"              = var.REGION
    }
  }
}

# alias pointing to latest for lambda function
resource "aws_lambda_alias" "lambda_alias" {
  name             = "latest"
  function_name    = aws_lambda_function.lambda.arn
  function_version = "$LATEST"
}

# eventbridge rule
resource "aws_cloudwatch_event_rule" "pipeline_state_update" {
  name        = "${var.APP_NAME}-discord-codepipeline-rule"
  description = "capture state changes in all CodePipelines"

  event_pattern = <<PATTERN
  {
    "detail-type": [
        "CodePipeline Pipeline Execution State Change"
    ],
    "source": [
        "aws.codepipeline"
    ]
 }
PATTERN
}

# allow eventbridge to invoke lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.pipeline_state_update.arn
  qualifier     = aws_lambda_alias.lambda_alias.name
}

# map event rule to trigger lambda function
resource "aws_cloudwatch_event_target" "lambda_trigger" {
  rule = aws_cloudwatch_event_rule.pipeline_state_update.name
  arn  = aws_lambda_alias.lambda_alias.arn
}