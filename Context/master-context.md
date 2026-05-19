# IDMS Master Context

## Project Overview

Integrated Document Management System (IDMS) is a workflow-centric enterprise platform for managing institutional correspondence documents.

The system is NOT a generic file storage application.

The platform focuses on:
- workflow orchestration
- metadata governance
- audit trail
- approval lifecycle
- hybrid cloud/on-prem document management

---

# MVP Scope

Current MVP only focuses on:
- korespondensi workflow
- dokumen keluar (Users Create the Documents)
- dokumen masuk (Users Receive the Documents)

---

# Core Workflow

Dokumen Keluar:
DRAFT → REVIEW → REVISED → APPROVED → NUMBERED → SIGNED → FINALIZED → ARCHIVED

Dokumen Masuk:
RECEIVED → DISPOSED → IN_ACTION → STORED → ARCHIVED

---

# Architecture Direction

Hybrid architecture:
- Draft documents stored in Microsoft 365 / SharePoint Online
- Final documents stored in On-Prem repository
- Backend system is source of truth

---

# Core Principles

1. Workflow-centric system
2. Metadata-driven governance
3. Backend controls workflow state
4. SharePoint is storage only
5. API-first integration
6. Audit trail mandatory

---

# Main Modules

- Authentication
- Workflow Engine
- Metadata Management
- Document Service
- Numbering Service
- Audit Trail
- Search
- SharePoint Adapter
- Final Repository Adapter

---

# Technology Stack

Frontend:
- Next.js
- Tailwind CSS

Backend:
- Golang
- PostgreSQL

Integration:
- Microsoft Graph API
- SharePoint Online