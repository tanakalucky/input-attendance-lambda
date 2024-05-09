resource "aws_sqs_queue" "input-attendance-sqs" {
  name                      = "input-attendance-sqs"
  message_retention_seconds = 8640
  visibility_timeout_seconds = 360
}