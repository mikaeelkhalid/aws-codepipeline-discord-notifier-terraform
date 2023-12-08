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