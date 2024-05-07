# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
 
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = { Service = "lambda.amazonaws.com" },
      Effect    = "Allow",
      Sid       = ""
    }]
  })
}

# AmazonSESFullAccess policy
resource "aws_iam_role_policy_attachment" "lambda_ses_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# AWSLambdaBasicExecutionRole policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

# Lambda function
resource "aws_lambda_function" "terraform_lambda_func" {
  filename    = data.archive_file.lambda.output_path
  function_name = "terra_lambda_func"
  role        = aws_iam_role.lambda_role.arn
  handler     = "lambda_function.handler"
  runtime     = "python3.8"
  timeout     = 60
  memory_size = 128
  
}

# S3 bucket notification to trigger Lambda function on object creation/addition
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "terraform-bucket-dd"

  lambda_function {
    lambda_function_arn = aws_lambda_function.terraform_lambda_func.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "" 
  }
}

# Allow S3 bucket to invoke Lambda function
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::terraform-bucket-dd"
}
