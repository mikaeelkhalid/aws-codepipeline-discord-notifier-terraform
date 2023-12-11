# 🚀 AWS CodePipeline Discord Notifier using Terraform

[![Mikaeel Khalid](https://badgen.now.sh/badge/by/mikaeelkhalid/purple)](https://github.com/mikaeelkhalid)

## 📜 Overview

This Terraform module sets up an AWS Lambda function that sends notifications to a Discord channel via a webhook whenever there's
an update in the AWS CodePipeline executions. It is designed to help teams stay informed about their continuous integration and
continuous deployment (CI/CD) pipeline status.

## 📋 Prerequisites

Before you can use this module, you need the following:

- AWS Account with the necessary permissions to create the resources.
- Terraform installed and configured.
- A Discord channel and a corresponding webhook URL.

## 💽 Installation

1. Clone the repository to your local machine.
2. Navigate to the cloned directory.
3. Initialize the Terraform environment with `terraform init`.
4. Plan the deployment with `terraform plan`.
5. Apply the configuration with `terraform apply`.

## ⚙️ Configuration

Update the `variables.tf` file with your specific settings:

- `LAMBDA_APP_NAME`: Unique name for the Lambda function.
- `DISCORD_WEBHOOK_URL`: The Discord webhook URL to which the notifications will be sent.
- `DISCORD_CHANNEL`: The target Discord channel for notifications.
- `REGION`: AWS region where the resources will be deployed.
- `RELEVANT_STAGES`: The CodePipeline stages you want to receive notifications for.
- `LAMBDA_MEMORY_SIZE`: The amount of memory allocated to the Lambda function.
- `LAMBDA_TIMEOUT`: The maximum execution time for the Lambda function.

## 🛠 Usage

Once configured and applied, the Terraform module will create the following resources:

- AWS Lambda function: Listens for CodePipeline state changes and sends notifications.
- IAM Role and Policy: Grants the necessary permissions for the Lambda function.
- CloudWatch Event Rule: Triggers the Lambda function based on CodePipeline events.
- Lambda Alias: Points to the latest version of the Lambda function.

## 🔧 Maintenance

Check for updates to the Terraform AWS provider and update the `required_providers` block in `provider.tf` as necessary. Keep your
Discord webhook URL secret and rotate it periodically for security.

## 🆘 Support

For issues and feature requests, open an issue in the GitHub repository.

## 👥 Contributing

Contributions to this project are welcome. Please fork the repository, make your changes, and submit a pull request.

