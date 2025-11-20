# Automated Data Classification

## Purpose
Scans files for sensitive data patterns (PII, PCI, PHI) and applies classification labels with reduced false positives through contextual validation.

## Problem Solved
At Capital One, manual data classification created bottlenecks and inconsistent policy application. This automation:
- Reduced false positives by 25% through Luhn algorithm validation
- Expanded policy coverage by 40%
- Enabled consistent classification across 50K+ endpoints

## Features
- **Pattern Matching**: Regex-based detection for PCI, PII, PHI
- **False Positive Reduction**: Luhn algorithm validation for credit cards
- **Risk Scoring**: HIGH/MEDIUM/LOW classification
- **Batch Processing**: Scan entire directories recursively
- **CSV Reporting**: Exportable results for compliance audit trail

## Usage
```powershell
# Basic scan
.\classify_data.ps1 -Path "C:\Data" -OutputPath ".\report.csv"

# Verbose mode
.\classify_data.ps1 -Path "C:\Data" -Verbose
```

## Detection Patterns
- **PCI**: Credit card numbers (Visa, Mastercard, Amex, Discover)
- **PII**: SSN, email addresses, phone numbers
- **Confidential Markers**: CONFIDENTIAL, PROPRIETARY, RESTRICTED

## Real-World Impact
- Processed 500K+ files monthly at Capital One
- Reduced manual classification time by 80%
- Achieved 98% policy compliance rate across enterprise