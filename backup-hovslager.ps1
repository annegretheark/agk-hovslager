$SupabaseUrl = "https://pxlbrywowphkczkehmee.supabase.co"
$SupabaseKey = "sb_publishable_tluvA83iCcKfmgfXetvz5g_farKpCTS"

$BackupMappe = "C:\SupabaseBackup\hovslager_" + (Get-Date -Format "yyyy-MM-dd_HH-mm")
New-Item -ItemType Directory -Force -Path $BackupMappe | Out-Null
$Tabeller = @(
     "firma",
    "hester",
    "hov_fakturaer",
    "hov_jobber",
    "hov_kreditnotaer",
    "kunder"
)

$Headers = @{
    "apikey" = $SupabaseKey
    "Authorization" = "Bearer $SupabaseKey"
    "Accept" = "text/csv"
}

foreach ($Tabell in $Tabeller) {

    Write-Host "Tar backup av $Tabell ..."

    $Url = "$SupabaseUrl/rest/v1/$Tabell`?select=*"

    try {

        $Fil = Join-Path $BackupMappe "$Tabell.csv"

        Invoke-WebRequest `
            -Uri $Url `
            -Headers $Headers `
            -Method Get `
            -OutFile $Fil

        Write-Host "OK: $Fil"

    }
    catch {
        Write-Host "FEIL på $Tabell : $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ""
Write-Host "Backup ferdig:"
Write-Host $BackupMappe