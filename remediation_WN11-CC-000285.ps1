<#
.SYNOPSIS
    This PowerShell script requires secure RPC communication for the Remote Desktop Session Host.
.NOTES
    Author          : Symone-Marie Priester
    LinkedIn        : linkedin.com/in/symone-mariepriester
    GitHub          : github.com/Symone-Marie
    Date Created    : 2025-02-19
    Last Modified   : 2025-02-19
    Version         : Microsoft Windows [Version 10.0.26200.7623]
    CVEs            : N/A
    Vuln-ID         : V-253405
    STIG-ID         : WN11-CC-000285
.TESTED ON
    Date(s) Tested  : 2025-02-19
    Tested By       : Symone-Marie Priester
    Systems Tested  : Windows 11 Pro OS
    PowerShell Ver. : 5.1
    Manual Test     : Yes, remediated via Local Group Policy Editor (gpedit.msc) with screenshot documentation
.USAGE
    Enables secure RPC communication requirement for Remote Desktop Session Host.
    Example syntax:
    PS C:\> .\remediation_WN11-CC-000285.ps1
#>

# Define registry path and value
$regPath  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$regName  = "fEncryptRPCTraffic"
$regValue = 1  # 1 = Enabled (Require secure RPC communication)

Write-Host "Configuring Remote Desktop Session Host - Requiring secure RPC communication..."

# Create registry path if it doesn't exist
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "Created registry path: $regPath"
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord
Write-Host "Set $regName to $regValue (Enabled - Require secure RPC communication)"

# Verify the change
Write-Host "`nVerifying configuration..."
$currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

if ($currentValue.$regName -eq $regValue) {
    Write-Host "SUCCESS: WN11-CC-000285 remediated - Secure RPC communication is required" -ForegroundColor Green
    Write-Host "`nCurrent registry value:"
    Get-ItemProperty -Path $regPath -Name $regName | Select-Object fEncryptRPCTraffic
} else {
    Write-Host "ERROR: Failed to set registry value" -ForegroundColor Red
}

# Apply Group Policy changes immediately
Write-Host "`nApplying Group Policy update..."
gpupdate /force
