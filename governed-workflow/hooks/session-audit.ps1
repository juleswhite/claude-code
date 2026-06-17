# Stop hook — appends a session audit line so you have a trail of every session end,
# and clears this session's push-enable flags so they never leak into the next session.
$ErrorActionPreference = 'SilentlyContinue'

try {
    $raw = [Console]::In.ReadToEnd()
    $input = $raw | ConvertFrom-Json
    $sessionId = $input.session_id
    $cwd = $input.cwd

    $logDir = "$env:USERPROFILE\.claude\logs"
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    $logFile = Join-Path $logDir "sessions.log"

    $ts = Get-Date -Format o
    $line = "$ts`tsession=$sessionId`tcwd=$cwd"
    Add-Content -Path $logFile -Value $line -Encoding utf8

    # Cleanup this session's push-enable flags so a new session starts locked down again
    $flagDir = "$env:USERPROFILE\.claude\session-env"
    foreach ($suffix in @('push-ok','push-protected-ok')) {
        $flag = Join-Path $flagDir "$sessionId.$suffix"
        if (Test-Path $flag) { Remove-Item $flag -Force }
    }

    exit 0
} catch {
    exit 0
}
