data "archive_file" "input-attendance-sqs" {
  type        = "zip"
  source_dir  = "../../src/add_sqs"
  output_path = "../../build/add_sqs/function.zip"
}

resource "aws_lambda_function" "input-attendance-sqs" {
  function_name    = "input-attendance-sqs"
  filename         = data.archive_file.input-attendance-sqs.output_path
  source_code_hash = data.archive_file.input-attendance-sqs.output_base64sha256
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda_function.lambda_handler"
}
