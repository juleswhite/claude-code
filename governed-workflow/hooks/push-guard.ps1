# PreToolUse hook for Bash / PowerShell
# Two-tier git push gate (sole source of truth - settings.json no longer blanket-blocks push):
#   tier-1 flag (.push-ok)           -> push to non-protected branches
#   tier-2 flag (.push-protected-ok) -> push to protected branches too
# Force push is blocked unconditionally regardless of any flag.
# Also catches shell-wrapper evasion (bash -c, sh -c, eval, iex) of git push.
$ErrorActionPreference = 'Stop'

function Block($msg) {
    [Console]::Error.WriteLine($msg)
    exit 2
}

try {
    $raw = [Console]::In.ReadToEnd()
    $payload = $raw | ConvertFrom-Json
    $sessionId = $payload.session_id
    $cmd = [string]$payload.tool_input.command
    if (-not $cmd) { exit 0 }

    $lower = $cmd.ToLower()

    # Catch evasion attempts even if the deny-list missed them.
    # Anchor on start-of-command or shell separator so commit-message bodies that
    # merely mention "git push" don't false-positive.
    if ($lower -match '(^|[;&|`\n]\s*)git\s+push\b') {
        $sessionDir   = "$env:USERPROFILE\.claude\session-env"
        $okFlag        = "$sessionDir\$sessionId.push-ok"
        $protectedFlag = "$sessionDir\$sessionId.push-protected-ok"

        # Tier 1: any push at all requires the sentinel phrase this session
        if (-not (Test-Path $okFlag)) {
            Block "[push-guard] git push is BLOCKED. User must type the tier-1 sentinel phrase 'push this branch now' to enable pushing to non-protected branches this session. Do NOT attempt to bypass this - surface the block to the user."
        }
        # Force push: blocked unconditionally, regardless of any flag
        if ($lower -match '--force|--force-with-lease|\s-f(\s|$)') {
            Block "[push-guard] Force push is BLOCKED unconditionally. Ask the user how to proceed."
        }
        # Tier 2: protected branches require the stronger override phrase
        if ($lower -match '\b(main|master|production|prod|release|staging|develop)\b') {
            if (-not (Test-Path $protectedFlag)) {
                Block "[push-guard] Push targets a protected branch (main/master/prod/release/staging/develop). BLOCKED. User must type the tier-2 phrase 'override protected push now' to allow protected-branch pushes this session. Surface this to the user - do not bypass."
            }
        }
    }

    exit 0
} catch {
    # On hook error, fail closed for git push, open for everything else
    if ($cmd -and $cmd.ToLower() -match '(^|[;&|`\n]\s*)git\s+push\b') {
        Block "[push-guard] Hook error; blocking push as a precaution. $($_.Exception.Message)"
    }
    exit 0
}
