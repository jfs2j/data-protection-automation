"""
DLP Alert Enrichment Tool
Enhances raw DLP alerts with user context, risk scoring, and automated triage recommendations.

Author: Joel Sop
Use Case: Reduces mean-time-to-respond by enriching alerts with actionable context
"""

import json
import re
from datetime import datetime
from typing import Dict, List

class AlertEnricher:
    """Enriches DLP alerts with user context and risk scoring."""
    
    def __init__(self, user_database: Dict = None):
        """Initialize with user context database."""
        self.user_db = user_database or self._load_mock_user_db()
        self.risk_scores = {
            'HIGH': 90,
            'MEDIUM': 50,
            'LOW': 20
        }
    
    def _load_mock_user_db(self) -> Dict:
        """Mock user database for demonstration."""
        return {
            'jsmith@company.com': {
                'department': 'Engineering',
                'manager': 'agarcia@company.com',
                'hire_date': '2020-01-15',
                'clearance': 'Standard',
                'previous_incidents': 0
            },
            'bmiller@company.com': {
                'department': 'Finance',
                'manager': 'rwilson@company.com',
                'hire_date': '2019-03-22',
                'clearance': 'Elevated',
                'previous_incidents': 2
            }
        }
    
    def enrich_alert(self, alert: Dict) -> Dict:
        """
        Enrich a raw DLP alert with user context and risk scoring.
        
        Args:
            alert: Raw alert dictionary containing user, action, data_type
            
        Returns:
            Enriched alert with user context, risk score, and triage recommendation
        """
        enriched = alert.copy()
        
        # Add user context
        user_email = alert.get('user')
        user_context = self.user_db.get(user_email, {})
        enriched['user_context'] = user_context
        
        # Calculate risk score
        risk_score = self._calculate_risk_score(alert, user_context)
        enriched['risk_score'] = risk_score
        enriched['risk_level'] = self._get_risk_level(risk_score)
        
        # Add triage recommendation
        enriched['triage_recommendation'] = self._get_triage_recommendation(
            risk_score, 
            alert.get('data_type'),
            user_context
        )
        
        # Add enrichment timestamp
        enriched['enriched_at'] = datetime.utcnow().isoformat()
        
        return enriched
    
    def _calculate_risk_score(self, alert: Dict, user_context: Dict) -> int:
        """Calculate risk score based on alert and user context."""
        base_score = 30
        
        # Data sensitivity scoring
        data_type = alert.get('data_type', '').upper()
        if 'PCI' in data_type or 'PAYMENT' in data_type:
            base_score += 40
        elif 'PII' in data_type or 'SSN' in data_type:
            base_score += 35
        elif 'CONFIDENTIAL' in data_type:
            base_score += 25
        
        # Action type scoring
        action = alert.get('action', '').lower()
        if action in ['upload', 'email_external', 'cloud_share']:
            base_score += 25
        elif action in ['copy', 'download']:
            base_score += 15
        
        # User history scoring
        previous_incidents = user_context.get('previous_incidents', 0)
        base_score += (previous_incidents * 10)
        
        # Department risk adjustment
        high_risk_depts = ['Finance', 'Legal', 'Executive']
        if user_context.get('department') in high_risk_depts:
            base_score += 10
        
        # Clearance level adjustment (lower clearance = higher risk)
        if user_context.get('clearance') == 'Standard':
            base_score += 15
        
        return min(base_score, 100)  # Cap at 100
    
    def _get_risk_level(self, risk_score: int) -> str:
        """Convert risk score to risk level."""
        if risk_score >= 70:
            return 'HIGH'
        elif risk_score >= 40:
            return 'MEDIUM'
        else:
            return 'LOW'
    
    def _get_triage_recommendation(
        self, 
        risk_score: int, 
        data_type: str, 
        user_context: Dict
    ) -> str:
        """Generate triage recommendation based on risk factors."""
        if risk_score >= 70:
            return (
                f"IMMEDIATE ACTION REQUIRED: High-risk data movement detected. "
                f"Contact user's manager ({user_context.get('manager', 'Unknown')}) "
                f"and initiate incident investigation."
            )
        elif risk_score >= 40:
            return (
                f"REVIEW REQUIRED: Medium-risk activity. Verify business justification "
                f"with user within 24 hours. Department: {user_context.get('department', 'Unknown')}"
            )
        else:
            return (
                f"LOW PRIORITY: Likely legitimate activity. Log for audit trail. "
                f"No immediate action required."
            )
    
    def batch_enrich(self, alerts: List[Dict]) -> List[Dict]:
        """Enrich multiple alerts."""
        return [self.enrich_alert(alert) for alert in alerts]


def main():
    """Example usage of AlertEnricher."""
    # Sample raw DLP alert
    raw_alert = {
        'alert_id': 'DLP-2024-11-001',
        'timestamp': '2024-11-18T14:30:00Z',
        'user': 'bmiller@company.com',
        'action': 'email_external',
        'data_type': 'PCI_CREDIT_CARD',
        'destination': 'external_recipient@vendor.com',
        'file_name': 'Q4_Financial_Report.xlsx',
        'matched_rules': ['PCI-EMAIL-001', 'SENSITIVE-DATA-002']
    }
    
    # Initialize enricher
    enricher = AlertEnricher()
    
    # Enrich alert
    enriched_alert = enricher.enrich_alert(raw_alert)
    
    # Display results
    print("=" * 60)
    print("DLP ALERT ENRICHMENT RESULTS")
    print("=" * 60)
    print(json.dumps(enriched_alert, indent=2))
    print("\n" + "=" * 60)
    print(f"Risk Level: {enriched_alert['risk_level']}")
    print(f"Risk Score: {enriched_alert['risk_score']}/100")
    print(f"Triage: {enriched_alert['triage_recommendation']}")
    print("=" * 60)


if __name__ == '__main__':
    main()
