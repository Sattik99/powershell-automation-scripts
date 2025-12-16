# PowerShell IT Automation Scripts

This repository contains a curated collection of PowerShell scripts used to automate common and repetitive IT administration tasks in Windows enterprise environments.

The scripts are designed with a focus on reliability, safety, and operational efficiency, and reflect real-world scenarios encountered in endpoint management, identity administration, and system maintenance.

---

## Scope & Use Cases

The scripts in this repository support tasks across the following areas:

- Active Directory user and group management
- Microsoft Intune and endpoint administration
- Windows 10/11 system maintenance and health checks
- Automation of repetitive operational tasks
- Troubleshooting and administrative tooling

This repository serves both as a **personal automation toolkit** and as a **reference knowledge base** for production-style PowerShell solutions.

---

## Repository Structure

powershell-automation-scripts/
│
├── AD/
│ Scripts related to Active Directory administration
│
├── Utilities/
│ Reusable helper scripts and general-purpose tools
│
└── README.md



Folder names reflect functional areas to keep scripts organized and easy to navigate.

---

## Environment Assumptions

Most scripts are written and tested with the following assumptions:

- Windows 10 / Windows 11
- PowerShell 5.1 or PowerShell 7+
- Appropriate administrative privileges
- Domain-joined or Entra ID-joined environments (depending on script)

Specific requirements, if any, are documented within individual scripts.

---

## Usage Notes

- Scripts are intended to be reviewed and adapted before use in production environments.
- Always test scripts in a non-production or lab environment first.
- No hardcoded credentials or tenant-specific identifiers are included.
- Scripts follow a clear and readable structure with inline comments for maintainability.

---

## Disclaimer

All scripts are provided as-is for educational and operational reference purposes.  
Users are responsible for validating behavior and ensuring compliance with their organization’s policies before execution.

---

## Author

Maintained by **Akib Sattik**  
Senior IT Support Analyst | Intune & Entra ID | PowerShell Automation
