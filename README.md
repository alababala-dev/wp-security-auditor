# WordPress Security Auditor & Hardening Suite
### **Automated Penetration Testing & Firewall Verification**

## 🛡️ Project Overview
This project contains a custom **Bash-based Security Auditing Tool** designed to stress-test WordPress and WooCommerce environments. It simulates common attacker methodologies to verify that server-side hardening and Web Application Firewalls (WAF) are functioning correctly.

## 🔍 Audit Capabilities
The script performs 13 distinct security checks, including:
* **Config Exposure:** Probing for `.env`, `wp-config.php`, and `.git` leaks.
* **User Enumeration:** Testing REST API and author-scan vulnerabilities.
* **Brute-Force Verification:** Stress-testing login endpoints to verify rate-limiting.
* **WAF Validation:** Confirming that Cloudflare/Server-level challenges are triggered by bot-like behavior.

## 📊 Sample Audit Analysis (External Attacker Simulation)
When run from an external IP (simulating a real-world threat), the audit results demonstrate high-level hardening:

* **Managed Challenges:** Test 8 (Robots.txt) successfully triggered a **Cloudflare Managed Challenge**, preventing automated scrapers from mapping the site structure.
* **Endpoint Protection:** Test 12 (Login Protection) returned **HTTP 403** across all rapid-fire attempts, confirming active brute-force mitigation.
* **Version Obfuscation:** Tests 6 & 10 confirm that versioning and plugin fingerprints are successfully hidden from public view.

## 🛠️ Usage
```bash
chmod +x audit.sh
./audit.sh
