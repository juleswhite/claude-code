# UserPromptSubmit hook
# If user types the sentinel phrase, drop a per-session flag that push-guard checks.
$ErrorActionPreference = 'Stop'

try {
    $raw = [Console]::In.ReadToEnd()
    $payload = $raw | ConvertFrom-Json
    $sessionId = $payload.session_id
    $prompt = [string]$payload.prompt

    if (-not $sessionId) { exit 0 }

    $flagDir = "$env:USERPROFILE\.claude\session-env"
    if (-not (Test-Path $flagDir)) { New-Item -ItemType Directory -Path $flagDir -Force | Out-Null }
    $okFlag        = Join-Path $flagDir "$sessionId.push-ok"
    $protectedFlag = Join-Path $flagDir "$sessionId.push-protected-ok"
    $stamp = Get-Date -Format o

    # Tier 2 (protected) implies tier 1. Check it first so the stronger phrase wins.
    if ($prompt -match '(?i)override protected push now') {
        Set-Content -Path $okFlag        -Value $stamp -Encoding utf8
        Set-Content -Path $protectedFlag -Value $stamp -Encoding utf8
        Write-Output "[push-guard] Tier-2 override detected. git push is allowed this session INCLUDING protected branches (main/master/prod/release/staging/develop). Force-push remains blocked unconditionally."
    }
    elseif ($prompt -match '(?i)push this branch now') {
        Set-Content -Path $okFlag -Value $stamp -Encoding utf8
        Write-Output "[push-guard] Tier-1 sentinel phrase detected. git push to non-protected branches is allowed this session. Protected branches stay blocked - type 'override protected push now' to allow those."
    }
    exit 0
} catch {
    # Never block prompt submission on hook error
    exit 0
}
