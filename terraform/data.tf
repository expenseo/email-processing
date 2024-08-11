data "archive_file" "build_zip" {
  type        = "zip"
  source_dir  = "${path.module}/dist"
  output_path = "${path.module}/${local.build_file_name}"
}
