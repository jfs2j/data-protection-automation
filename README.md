# data-protection-automation
Enterprise data protection automation tools: DLP alert enrichment, data classification, and policy enforcement.

# Data Protection Automation Portfolio

**Author:** Joel Sop | [LinkedIn](https://linkedin.com/in/JoelSop) | [jfs2j@virginia.edu](mailto:jfs2j@virginia.edu)

Enterprise-scale data protection automation tools built from 8 years architecting DLP and data governance programs at Capital One. These tools demonstrate practical approaches to reducing mean-time-to-respond, improving classification accuracy, and scaling privacy operations without linear headcount growth.

---

## 🎯 Portfolio Overview

This repository showcases three core automation capabilities I've built in production environments:

| Tool | Purpose | Impact |
|------|---------|--------|
| **DLP Alert Enrichment** | Adds user context and risk scoring to raw DLP alerts | Reduced MTTR by 35%, enabled 40% higher case volume |
| **Data Classification** | Automated sensitive data discovery with false positive reduction | Reduced FP by 25%, expanded coverage by 40% |
| **Policy Automation** | Dynamic policy enforcement based on data context | Maintained 90% deployment velocity with 98% compliance |

---

## 📁 Repository Structure

data-protection-automation/
│
├── dlp-alert-enrichment/       # Python-based alert enrichment
├── data-classification/        # PowerShell data classification scanner
├── policy-automation/          # Policy enforcement engine
└── README.md                   # This file


---

## 🚀 Quick Start

### Prerequisites
- Python 3.8+ (for Python scripts)
- PowerShell 5.1+ (for PowerShell scripts)

### Installation
```bash
# Clone repository
git clone https://github.com/jfs2j/data-protection-automation.git
cd data-protection-automation

# Install Python dependencies
pip install -r requirements.txt

# Run alert enrichment demo
cd dlp-alert-enrichment
python alert_enricher.py

# Run data classification demo (Windows/PowerShell)
cd ../data-classification
.\classify_data.ps1 -Verbose
```

---

## 💡 Philosophy: Automation as Scale Enabler

At Capital One, I learned that **effective data protection scales through automation, not headcount**. These tools embody three core principles:

### 1. **Context Over Volume**
Raw DLP alerts lack actionable context. By enriching alerts with user department, manager info, and historical behavior, analysts can triage faster and more accurately.

### 2. **Precision Over Recall**
False positives erode trust in DLP systems. By implementing validation logic (e.g., Luhn algorithm for credit cards), we reduce noise while maintaining detection coverage.

### 3. **Enablement Over Control**
Data protection should enable business velocity, not slow it down. By automating policy enforcement and providing clear guidance, teams can move fast while managing risk.

---

## 🏆 Real-World Impact

These automation approaches delivered measurable outcomes at Capital One:

- **35% reduction** in mean-time-to-respond for DLP incidents
- **60% reduction** in manual alert triage time
- **25% reduction** in false positive rate
- **40% increase** in SOC case handling capacity (no headcount growth)
- **98% policy compliance rate** while maintaining 90% deployment frequency

---

## 🔧 Technical Stack

**Languages:** Python, PowerShell, Bash  
**Data Protection Platforms:** Netskope, Symantec, Proofpoint, Microsoft Purview  
**Cloud:** AWS (GuardDuty, CloudTrail, S3), Azure, GCP  
**SIEM:** Splunk, Chronicle  
**Automation:** API integration, webhook-based workflows

---

## 📚 Use Cases

### Financial Services
- PCI-DSS compliance automation
- Credit card data detection and remediation
- Cross-border data transfer monitoring

### Healthcare
- HIPAA-compliant data classification
- PHI discovery and protection
- Patient data retention automation

### Entertainment/Streaming
- User viewing history protection
- Content licensing data governance
- Ad-tier consent management

---

## 🤝 Contributing

This is a portfolio repository demonstrating production-proven automation patterns. While not actively maintained as an open-source project, the code is provided under MIT License for educational and reference purposes.

**Feedback welcome:** If you're implementing similar automation and have questions, feel free to reach out via LinkedIn or email.

---

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

---

## 👤 About Me

I'm Joel Sop, a Principal Data Protection Engineer with 8 years building enterprise-scale data governance and privacy infrastructure. I specialize in balancing regulatory compliance with business enablement through pragmatic automation and cross-functional leadership.

**Currently:** Exploring opportunities in consumer privacy and streaming data protection.

**Connect:** [LinkedIn](https://linkedin.com/in/JoelSop) | [GitHub](https://github.com/jfs2j) | [Email](mailto:jfs2j@virginia.edu)

---

## 📊 Repository Stats

![Python](https://img.shields.io/badge/Python-3.8%2B-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Portfolio-orange)