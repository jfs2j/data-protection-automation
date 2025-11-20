# DLP Alert Enrichment

## Purpose
Reduces mean-time-to-respond by enriching raw DLP alerts with user context, risk scoring, and automated triage recommendations.

## Problem Solved
At Capital One, I reduced MTTR by 35% by building automation that enriched DLP alerts with:
- User department and manager information
- Historical incident data
- Risk-based scoring
- Automated triage recommendations

This sample demonstrates the core enrichment logic.

## How It Works
1. **User Context Lookup**: Pulls employee data (department, manager, clearance level)
2. **Risk Scoring**: Calculates 0-100 risk score based on:
   - Data sensitivity (PCI > PII > Confidential)
   - Action type (external upload > download)
   - User history (previous incidents)
   - Department risk profile
3. **Triage Recommendation**: Generates actionable next steps for SOC analysts

## Usage
```bash
python alert_enricher.py
```

## Example Output
```json
{
  "alert_id": "DLP-2024-11-001",
  "risk_score": 85,
  "risk_level": "HIGH",
  "user_context": {
    "department": "Finance",
    "manager": "rwilson@company.com",
    "previous_incidents": 2
  },
  "triage_recommendation": "IMMEDIATE ACTION REQUIRED: High-risk data movement detected..."
}
```

## Real-World Impact
- Reduced manual alert triage time by 60%
- Enabled SOC to handle 40% higher alert volume without additional headcount
- Improved incident response accuracy through consistent risk scoring