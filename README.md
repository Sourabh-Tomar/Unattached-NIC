# 📘 Azure Unattached NIC Cleanup & Email Notification

This repository contains PowerShell automation to identify **unattached Azure Network Interfaces (NICs)** and **send HTML reports via email** using Azure Automation.

---

## ⚙️ Prerequisites

Ensure the following are configured in your Azure environment:

- ✅ An **Azure Automation Account** with:
  - Imported **Az modules**: `Az.Accounts`, `Az.Network`
  - **Managed Identity** (System-Assigned or User-Assigned) with **Reader** access on subscriptions
- 📧 SMTP Access:
  - Gmail (with App Password) or domain SMTP server
- 🔐 Azure Automation Variables:
  - `GmailAppPassword` → App Password stored as a **secure string variable**

---

## 📁 Repository Structure

**/scripts/**
  - Azure_Runbook_Unattached_NIC_by_email_Report.ps1
  - Unattached_NIC_Report_Output.ps1

**/docs/**
  - Outputs of both Scripts Azure Runbook and local.pdf

**README.md**

---

## 📜 Scripts Included

This repository includes **two PowerShell scripts**:

### 🔍 `Unattached_NIC_Report_Output.ps1`
- Scans **all Azure subscriptions** for **unattached NICs**
- Filters out NICs not connected to any **VM** or **Private Endpoint**

### 📧 `Azure_Runbook_Unattached_NIC_by_email_Report.ps1`
- Formats the NIC report in **HTML**
- Sends the report via **email** using **SMTP** from the Automation Runbook

---

## 📌 Features

- ✅ Supports **multiple subscriptions**
- 🔐 Uses **Managed Identity** (no credential hardcoding)
- ⚠️ Optional support for **excluding specific subscriptions**
- 💌 Sends a **formatted HTML report** (Gmail or domain-based SMTP)
- ⏰ Supports **Azure Automation scheduling**
- 🔒 Stores **email credentials securely** using Automation Variables

---

## ⏲️ Schedule the Runbook

You can automate the report execution using Azure Automation schedules.

### Steps:
1. Go to: `Azure Portal → Automation Account → Runbooks`
2. Select your runbook
3. Click **"Link to schedule"**
4. Choose:
   - Daily / Weekly / Monthly
   - Off-peak hours (recommended)



