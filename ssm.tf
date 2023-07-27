resource "aws_ssm_document" "foo" {
  name          = "test_document"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Check ip configuration of a Linux instance.",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["ifconfig"]
          }
        ]
      }
    }
  }
   DOC
}
resource "aws_ssm_association" "example" {
  name = aws_ssm_document.example.name

  targets {
    key    = "tag::run_ssm_documnet"
    values = ["yes"]
  }
}