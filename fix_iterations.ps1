# PowerShell script to fix unsafe table iterations
$files = @("games/universal.lua", "games/6872274481.lua")

foreach ($file in $files) {
    if (Test-Path $file) {
        [System.IO.File]::ReadAllText($file) | `
            ForEach-Object { $_ -creplace 'for _, v in entitylib\.List do', 'for _, v in ipairs(entitylib.List) do' } | `
            Out-File $file -Encoding UTF8 -NoNewline
        Write-Host "Fixed: $file"
    }
}
