data "archive_file" "input-attendance-lambda" {
  type        = "zip"
  source_dir  = "../../src/input_attendance"
  output_path = "../../build/input_attendance/function.zip"
}

resource "aws_lambda_function" "input-attendance-lambda" {
  function_name    = "input-attendance-lambda"
  filename         = data.archive_file.input-attendance-lambda.output_path
  source_code_hash = data.archive_file.input-attendance-lambda.output_base64sha256
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda_function.lambda_handler"
  timeout = 360
  memory_size = 256
}

# sqs event
resource "aws_lambda_event_source_mapping" "sqs_mapping" {
  event_source_arn  = aws_sqs_queue.input-attendance-sqs.arn
  function_name     = aws_lambda_function.input-attendance-lambda.function_name
  batch_size = 5
  depends_on = [ aws_sqs_queue.input-attendance-sqs, aws_lambda_function.input-attendance-lambda ]
}