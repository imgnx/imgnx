$fullPath = $args[0]
$relativePath = Split-Path $args[0] -NoQualifier
$relativePath = $relativePath -replace '\\', '/'
Read-Host "Press Enter to continue: $fullPath > dmholdingsinccom:imgfunnels.com$relativePath"
rclone -P -vv copy $fullPath dmholdingsinccom:imgfunnels.com$relativePath --exclude-from I:\IMGNX\.rclone.exclude 2>&1

if ($response.ExitCode -eq 0) {
  Write-Host "Success"
  bash -c '/i/IMGNX/integrity-check.sh "/i$relativePath"'
}
else {
  Write-Host "Failed: $response"
}
