<#
.SYNOPSIS
    Automated data classification for files based on content patterns and metadata.

.DESCRIPTION
    Scans files for sensitive data patterns (PII, PCI, PHI) and applies appropriate
    classification labels. Reduces false positives through contextual analysis.
    
.AUTHOR
    Joel Sop
    
.USE CASE
    At Capital One, I built classification automation that reduced false positives by 25%
    while expanding policy coverage by 40%.

.EXAMPLE
    .\classify_data.ps1 -Path "C:\Data\Financial" -OutputPath ".\classification_report.csv"
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$Path = ".\sample_data",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".\classification_report.csv",
    
    [Parameter(Mandatory=$false)]
    [switch]$Verbose
)

# Classification patterns
$ClassificationPatterns = @{
    'PCI_CREDIT_CARD' = @{
        'Pattern' = '\b(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|6(?:011|5[0-9]{2})[0-9]{12}|(?:2131|1800|35\d{3})\d{11})\b'
        'Description' = 'Credit Card Number (PCI-DSS)'
        'RiskLevel' = 'HIGH'
        'Confidence' = 0.95
    }
    'PII_SSN' = @{
        'Pattern' = '\b\d{3}-\d{2}-\d{4}\b'
        'Description' = 'Social Security Number'
        'RiskLevel' = 'HIGH'
        'Confidence' = 0.90
    }
    'PII_EMAIL' = @{
        'Pattern' = '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
        'Description' = 'Email Address'
        'RiskLevel' = 'MEDIUM'
        'Confidence' = 0.85
    }
    'PII_PHONE' = @{
        'Pattern' = '\b(?:\+?1[-.]?)?\(?([0-9]{3})\)?[-.]?([0-9]{3})[-.]?([0-9]{4})\b'
        'Description' = 'Phone Number'
        'RiskLevel' = 'LOW'
        'Confidence' = 0.80
    }
    'CONFIDENTIAL_MARKER' = @{
        'Pattern' = '\b(?:CONFIDENTIAL|PROPRIETARY|INTERNAL ONLY|RESTRICTED)\b'
        'Description' = 'Confidential Content Marker'
        'RiskLevel' = 'MEDIUM'
        'Confidence' = 0.70
    }
}

# Initialize results array
$Results = @()

function Test-LuhnAlgorithm {
    <#
    .SYNOPSIS
        Validates credit card numbers using Luhn algorithm to reduce false positives.
    #>
    param([string]$Number)
    
    $Number = $Number -replace '\D', ''
    if ($Number.Length -lt 13 -or $Number.Length -gt 19) { return $false }
    
    $sum = 0
    $alternate = $false
    
    for ($i = $Number.Length - 1; $i -ge 0; $i--) {
        $digit = [int]::Parse($Number[$i].ToString())
        
        if ($alternate) {
            $digit *= 2
            if ($digit -gt 9) { $digit -= 9 }
        }
        
        $sum += $digit
        $alternate = -not $alternate
    }
    
    return ($sum % 10 -eq 0)
}

function Get-FileClassification {
    param(
        [string]$FilePath,
        [string]$Content
    )
    
    $classifications = @()
    $highestRisk = 'LOW'
    $totalMatches = 0
    
    foreach ($category in $ClassificationPatterns.Keys) {
        $pattern = $ClassificationPatterns[$category].Pattern
        $matches = [regex]::Matches($Content, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        
        if ($matches.Count -gt 0) {
            # Special validation for credit cards
            if ($category -eq 'PCI_CREDIT_CARD') {
                $validMatches = 0
                foreach ($match in $matches) {
                    if (Test-LuhnAlgorithm -Number $match.Value) {
                        $validMatches++
                    }
                }
                if ($validMatches -eq 0) { continue }
                $matchCount = $validMatches
            } else {
                $matchCount = $matches.Count
            }
            
            $classifications += [PSCustomObject]@{
                'Category' = $category
                'Description' = $ClassificationPatterns[$category].Description
                'Matches' = $matchCount
                'RiskLevel' = $ClassificationPatterns[$category].RiskLevel
                'Confidence' = $ClassificationPatterns[$category].Confidence
            }
            
            $totalMatches += $matchCount
            
            # Update highest risk level
            $currentRisk = $ClassificationPatterns[$category].RiskLevel
            if ($currentRisk -eq 'HIGH') { $highestRisk = 'HIGH' }
            elseif ($currentRisk -eq 'MEDIUM' -and $highestRisk -ne 'HIGH') { $highestRisk = 'MEDIUM' }
        }
    }
    
    return @{
        'Classifications' = $classifications
        'HighestRisk' = $highestRisk
        'TotalMatches' = $totalMatches
    }
}

# Main processing
Write-Host "Starting data classification scan..." -ForegroundColor Cyan
Write-Host "Scanning path: $Path`n" -ForegroundColor Yellow

$files = Get-ChildItem -Path $Path -File -Recurse -Include *.txt,*.csv,*.log,*.json,*.xml

$fileCount = 0
foreach ($file in $files) {
    $fileCount++
    
    try {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction Stop
        
        $classification = Get-FileClassification -FilePath $file.FullName -Content $content
        
        if ($classification.TotalMatches -gt 0) {
            $result = [PSCustomObject]@{
                'FilePath' = $file.FullName
                'FileName' = $file.Name
                'FileSize' = $file.Length
                'LastModified' = $file.LastWriteTime
                'HighestRiskLevel' = $classification.HighestRisk
                'TotalMatches' = $classification.TotalMatches
                'Classifications' = ($classification.Classifications | ForEach-Object { "$($_.Category):$($_.Matches)" }) -join '; '
                'ScanTimestamp' = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            }
            
            $Results += $result
            
            if ($Verbose) {
                Write-Host "[MATCH] $($file.Name) - Risk: $($classification.HighestRisk) - Matches: $($classification.TotalMatches)" -ForegroundColor Green
            }
        }
        
    } catch {
        Write-Warning "Could not process file: $($file.FullName) - $($_.Exception.Message)"
    }
}

# Export results
if ($Results.Count -gt 0) {
    $Results | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "`nClassification complete!" -ForegroundColor Green
    Write-Host "Files scanned: $fileCount" -ForegroundColor Cyan
    Write-Host "Files with sensitive data: $($Results.Count)" -ForegroundColor Cyan
    Write-Host "Results exported to: $OutputPath`n" -ForegroundColor Yellow
    
    # Summary by risk level
    $highRisk = ($Results | Where-Object { $_.HighestRiskLevel -eq 'HIGH' }).Count
    $mediumRisk = ($Results | Where-Object { $_.HighestRiskLevel -eq 'MEDIUM' }).Count
    $lowRisk = ($Results | Where-Object { $_.HighestRiskLevel -eq 'LOW' }).Count
    
    Write-Host "Risk Level Summary:" -ForegroundColor Cyan
    Write-Host "  HIGH:   $highRisk files" -ForegroundColor Red
    Write-Host "  MEDIUM: $mediumRisk files" -ForegroundColor Yellow
    Write-Host "  LOW:    $lowRisk files" -ForegroundColor Green
} else {
    Write-Host "`nNo sensitive data patterns detected in scanned files." -ForegroundColor Yellow
}