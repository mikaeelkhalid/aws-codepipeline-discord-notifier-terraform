# installs NPM packages on every run for lambda function 
resource "null_resource" "install_lambda_function_packages" {
  triggers = {
    force_run = uuid()
  }
  provisioner "local-exec" {
    command = "cd ${path.module}/aws-codepipeline-discord-lambda && npm install"
  }
}
