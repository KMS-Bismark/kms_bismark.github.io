# 在本机起一个静态服务器，让同一局域网（Wi-Fi）下的手机 / 其它电脑也能访问
# 用法：在 codeforces-div2 目录下执行  pwsh ./serve.ps1
#      然后按提示在浏览器输入 http://<你的局域网IP>:8080

param([int]$Port = 8080)

$ErrorActionPreference = "Stop"

function Get-Python {
  foreach ($cmd in @("python", "py", "python3")) {
    $c = Get-Command $cmd -ErrorAction SilentlyContinue
    if ($c) { return $c.Source }
  }
  throw "没找到 Python。装一个 Python 3 即可（https://www.python.org/downloads/）。"
}

$python = Get-Python

$ips = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
  Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" } |
  Select-Object -ExpandProperty IPAddress -Unique

Write-Host ""
Write-Host "本机访问：  http://localhost:$Port/" -ForegroundColor Green
foreach ($ip in $ips) {
  Write-Host "手机/同网段访问： http://${ip}:$Port/" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "按 Ctrl+C 停止服务。" -ForegroundColor DarkGray
Write-Host ""

# 注意：如果 Windows 防火墙弹窗，请允许「专用网络」访问
Push-Location $PSScriptRoot
try {
  if ($python -match "py(\.exe)?$") {
    & $python -3 -m http.server $Port
  } else {
    & $python -m http.server $Port
  }
} finally {
  Pop-Location
}
