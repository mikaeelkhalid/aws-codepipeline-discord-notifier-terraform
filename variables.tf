variable "APP_NAME" {
  description = "lambda function name."
  default = "cicd-channel"
}

variable "DISCORD_WEBHOOK_URL" {
  description = "webhook URL provided by Discord."
  default = "https://mikaeels.com"
}

variable "DISCORD_CHANNEL" {
  description = "discord channel where messages are going to be posted."
  default = "#cicd"
}

variable "REGION" {
  description = "AWS deployment region."
  default     = "eu-west-2"
}

variable "RELEVANT_STAGES" {
  description = "stages for which you want to get notified (ie. 'SOURCE,BUILD,DEPLOY'). Defaults to all)"
  default     = "SOURCE,BUILD,DEPLOY"
}

variable "LAMBDA_MEMORY_SIZE" {
  default = "128"
}

variable "LAMBDA_TIMEOUT" {
  default = "10"
}


