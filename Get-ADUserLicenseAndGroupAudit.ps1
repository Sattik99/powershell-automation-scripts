<#
.SYNOPSIS
Generates an Active Directory user audit report (enabled users) including key attributes and group membership summary.

.DESCRIPTION
This script queries Active Directory for enabled user accounts and outputs a report containing:
- DisplayName, SamAccountName, UPN, Department, Title, Manager
- PasswordLastSet, LastLogonDate
- Group membership count and optional group names

It can export results to CSV for reporting and auditing purposes. The script is read-only.

.PARAMETER SearchBase
Optional OU distinguished name to scope the search (e.g., "OU=Users,DC=contoso,DC=com").

.PARAMETER IncludeGroupNames
If specified, includes a semicolon-separated list of group names per user.
Note: This may increase runtime in large environments.

.PARAMETER OutputPath
Path to export the CSV report.

.EXAMPLE
.\Get-ADUserLicenseAndGroupAudit.ps1

.EXAMPLE
.\Get-ADUserLicenseAndGroupAudit.ps1 -SearchBase "OU=Sydney,OU=Users,DC=bic,DC=local" -OutputPath "C:\Temp\AD-Audit.csv"

.EXAMPLE
.\Get-ADUserLicenseAndGroupAudit.ps1 -IncludeGroupNames -OutputPath "C:\Temp\AD-Audit-WithGroups.csv"

.NOTES
Author: Akib Sattik
Version: 1.0.0
This script is read-only. No changes are made to AD.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$SearchBase,

    [Parameter(Mandatory = $false)]
    [switch]$IncludeGroupNames,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath = "$(Join-Path $env:TEMP "AD-UserAudit-$(Get-Date -Format 'yyyyMMdd-HHmmss').csv")"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-Module {
    param([Parameter(Mandatory)][string]$ModuleName)

    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        throw "Required module '$ModuleName' not found. Install RSAT (Active Directory module) or run from a domain-joined admin workstation/server."
    }
}

function Write-Info {
    param([Parameter(Mandatory)][string]$Message)
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$ts] [INFO] $Message"
}

function Write-Warn {
    param([Parameter(Mandatory)][string]$Message)
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$ts] [WARN] $Message"
}

try {
    Assert-Module -ModuleName "ActiveDirectory"
    Import-Module ActiveDirectory -ErrorAction Stop

    Write-Info "Starting AD user audit..."
    if ($SearchBase) {
        Write-Info "Using SearchBase: $SearchBase"
    } else {
        Write-Info "No SearchBase provided. Querying entire directory (may take longer)."
    }

    $adParams = @{
        Filter     = 'Enabled -eq $true'
        Properties = @(
            'DisplayName','SamAccountName','UserPrincipalName','Department','Title','Manager',
            'PasswordLastSet','LastLogonDate'
        )
    }
    if ($SearchBase) { $adParams.SearchBase = $SearchBase }

    $users = Get-ADUser @adParams

    if (-not $users -or $users.Count -eq 0) {
        Write-Warn "No enabled users found for the specified scope."
        return
    }

    Write-Info ("Users retrieved: {0}" -f $users.Count)
    Write-Info "Building report (group lookup may take time if IncludeGroupNames is enabled)..."

    $report = foreach ($u in $users) {
        $managerName = $null
        if ($u.Manager) {
            try {
                $managerName = (Get-ADUser -Identity $u.Manager -Properties DisplayName).DisplayName
            } catch {
                $managerName = $u.Manager
            }
        }

        $groups = @()
        try {
            $groups = Get-ADPrincipalGroupMembership -Identity $u.SamAccountName |
                      Select-Object -ExpandProperty Name
        } catch {
            # Non-fatal: continue report generation
            $groups = @()
        }

        [pscustomobject]@{
            DisplayName         = $u.DisplayName
            SamAccountName      = $u.SamAccountName
            UserPrincipalName   = $u.UserPrincipalName
            Department          = $u.Department
            Title               = $u.Title
            Manager             = $managerName
            PasswordLastSet     = $u.PasswordLastSet
            LastLogonDate       = $u.LastLogonDate
            GroupCount          = $groups.Count
            Groups              = if ($IncludeGroupNames) { ($groups -join '; ') } else { $null }
        }
    }

    Write-Info "Exporting CSV to: $OutputPath"
    $report |
        Sort-Object Department, DisplayName |
        Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

    Write-Info "Done. Report rows: $($report.Count)"
    Write-Info "Tip: Open CSV in Excel and filter by Department / GroupCount / LastLogonDate."
}
catch {
    Write-Host "[ERROR] $($_.Exception.Message)"
    throw
}
