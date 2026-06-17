# PreToolUse hook for Read / Edit / Write / MultiEdit / NotebookEdit
# Blocks access to common secret/key file patterns.
$ErrorActionPreference = 'Stop'

function Block($msg) {
    [Console]::Error.WriteLine($msg)
    exit 2
}

try {
    $raw = [Console]::In.ReadToEnd()
    $input = $raw | ConvertFrom-Json
    $path = [string]$input.tool_input.file_path
    if (-not $path) { $path = [string]$input.tool_input.path }
    if (-not $path) { exit 0 }

    $p = $path.ToLower() -replace '\\','/'

    $patterns = @(
        '/\.env(\.|$|/)',
        '\.pem$',
        '\.pfx$',
        '\.p12$',
        '/id_rsa(\.|$)',
        '/id_ed25519(\.|$)',
        '/\.ssh/',
        '/secrets?/',
        '/credentials?(\.|$|/)',
        '/\.aws/credentials',
        '/\.aws/config',
        '/\.npmrc$',
        '/\.netrc$',
        '\.key$',
        'private[_-]?key',
        'service[_-]?account.*\.json$',
        'gcp[_-].*\.json$'
    )

    foreach ($pat in $patterns) {
        if ($p -match $pat) {
            Block "[secrets-guard] BLOCKED: '$path' matches a secret/key pattern ($pat). User must explicitly name this file in the task to allow access. Stop and ask the user."
        }
    }

    exit 0
} catch {
    exit 0
}
