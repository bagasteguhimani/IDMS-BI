# Login & Authentication Module — RBTD / PRD

# 1. Name

Login & Authentication Module

---

# 2. Description

The Login & Authentication Module is responsible for authenticating users before they can access the IDMS platform.

This module provides:
- secure login mechanism
- enterprise account authentication
- session/token management
- role initialization
- audit logging for authentication activities

The module integrates with the company HRIS / LDAP system to authenticate employees using their corporate work account credentials.

The HRIS / LDAP service acts as the primary identity source for employee authentication and profile synchronization.

The module also supports configurable dummy users for development, testing, and UAT purposes.

---

# 3. The Process

## Main Authentication Process

1. User opens IDMS login page
2. User enters corporate username and password
3. System sends authentication request to HRIS / LDAP
4. HRIS / LDAP validates credentials
5. System retrieves employee profile information
6. System validates account status
7. System initializes role and permissions
8. System generates authenticated session/token
9. System records login audit trail
10. User redirected to dashboard

---

## Failed Authentication Process

1. User enters invalid credentials
2. HRIS / LDAP rejects authentication
3. System records failed login attempt
4. System displays authentication error message
5. System increments failed login counter
6. System may temporarily lock account after configurable threshold

---

## Dummy User Authentication Process (Non-Production Only)

1. User enters dummy account credentials
2. System validates against local dummy configuration
3. System generates development session/token
4. System redirects user to dashboard

---

# 4. Flow Business Process

## Successful Login Flow

```text
User
  ↓
Open Login Page
  ↓
Input Corporate Credentials
  ↓
IDMS Authentication Service
  ↓
HRIS / LDAP Authentication
  ↓
Credential Validation
  ↓
Retrieve Employee Profile
  ↓
Role & Permission Initialization
  ↓
Generate Session / JWT
  ↓
Audit Logging
  ↓
Redirect to Dashboard
```

---

## Failed Login Flow

```text
User
  ↓
Input Invalid Credentials
  ↓
Authentication Service
  ↓
HRIS / LDAP Validation Failed
  ↓
Record Failed Attempt
  ↓
Display Error Message
```

---

## Dummy User Login Flow

```text
Developer / Tester
  ↓
Input Dummy Credentials
  ↓
Local Authentication Validation
  ↓
Generate Session
  ↓
Redirect to Dashboard
```

---

# 5. Output

## Successful Output

- authenticated user session
- JWT/session token
- employee profile information
- role and permission initialization
- login audit record

---

## Failed Output

- authentication failure message
- failed login audit log
- account lock information (if applicable)

---

# 6. Use Case

| Actor | Use Case | Description |
|---|---|---|
| Employee | Login | Authenticate into IDMS using corporate account |
| Employee | Logout | Terminate active session |
| System | Validate Credentials | Validate credentials through HRIS / LDAP |
| System | Synchronize User Profile | Retrieve employee information |
| System | Generate Session | Generate authenticated session/token |
| System | Audit Logging | Record authentication activity |
| Admin | Monitor Login Activity | Review login audit records |
| Admin | Manage Account Access | Manage role and access permissions |
| Developer / Tester | Login Using Dummy Account | Authenticate using development account |

---

# Functional Requirements

| ID | Requirement |
|---|---|
| FR-001 | System must provide login page |
| FR-002 | System must authenticate users through HRIS / LDAP |
| FR-003 | System must support secure session/token generation |
| FR-004 | System must support logout functionality |
| FR-005 | System must retrieve employee profile information |
| FR-006 | System must initialize user role and permissions |
| FR-007 | System must record login audit trail |
| FR-008 | System must support configurable account lock mechanism |
| FR-009 | System must support dummy users in non-production environment |
| FR-010 | System must support future SSO integration |

---

# Non-Functional Requirements

| ID | Requirement |
|---|---|
| NFR-001 | Authentication response time must be less than 3 seconds |
| NFR-002 | All authentication traffic must use HTTPS |
| NFR-003 | Sessions/tokens must have configurable expiration |
| NFR-004 | Audit logs must be immutable |
| NFR-005 | System must support concurrent user sessions |
| NFR-006 | Authentication service must support high availability |
| NFR-007 | System must support future MFA integration |

---

# Authentication Source

The IDMS platform shall integrate with the company's HRIS / LDAP service as the primary authentication source.

The HRIS / LDAP service acts as the source-of-truth for:
- employee identity
- username
- employee status
- organizational information

IDMS shall not store or manage primary employee passwords.

---

# API Contract — HRIS / LDAP Authentication

## Endpoint

```http
POST /api/auth/login
```

---

## Request Payload

```json
{
  "username": "john.doe",
  "password": "user-password"
}
```

---

## Successful Response Sample

```json
{
  "success": true,
  "employee_id": "EMP001",
  "username": "john.doe",
  "full_name": "John Doe",
  "email": "john.doe@company.com",
  "department": "Departmene Pengembangan dan Inovasi Digital",
  "company_group": "GKID",
  "jabatan": "Analis SI Yunior",
  "pangkat": "Asisten Manajer",
  "employment_status": "ACTIVE"
}
```

---

## Failed Response

```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

---

# Synchronization Rules

After successful authentication:
- user profile data shall be synchronized into IDMS
- organizational attributes shall be updated
- role mapping shall be initialized
- login audit shall be recorded

---

# Required Fields from HRIS

| Field | Mandatory |
|---|---|
| employee_id | Yes |
| username | Yes |
| full_name | Yes |
| email | Yes |
| department | Yes |
| company_group | Yes |
| jabatan | Yes |
| pangkat | Yes |
| employment_status | Yes |

---

# Error Handling

| Scenario | Expected Behavior |
|---|---|
| Invalid credentials | Reject authentication |
| HRIS unavailable | Return integration error |
| Missing mandatory fields | Reject synchronization |
| Timeout | Log integration failure |

---

# Dummy User Requirements

Dummy users shall only be enabled in:
- local development environment
- development environment
- testing/UAT environment

Dummy users must NOT be enabled in production.

---

# Dummy Users

## Administrator Account

| Field | Value |
|---|---|
| Username | admin |
| Password | admin123 |
| Role | Administrator |

---

## Standard User Account

| Field | Value |
|---|---|
| Username | user |
| Password | user123 |
| Role | Standard User |

---

# Security Considerations

The authentication module must follow enterprise security standards and OWASP authentication guidance, including:
- secure session management
- HTTPS-only communication
- secure token handling
- account lockout mechanisms
- audit logging
- MFA readiness
- RBAC integration
- brute-force protection

The system must ensure:
- LDAP credentials are never stored locally
- secure communication with HRIS / LDAP
- authentication logs remain auditable
- local fallback authentication disabled in production

---

# Exception Handling

## HRIS / LDAP Unavailable

If HRIS / LDAP service becomes unavailable:
- authentication requests shall be rejected
- system shall display appropriate error message
- integration failure shall be logged
- dummy users may continue operating in non-production environment only

---

# 7. ERD Diagram

## Entity: users

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| employee_id | VARCHAR | Employee identifier from HRIS |
| username | VARCHAR | Corporate username |
| email | VARCHAR | Employee email |
| full_name | VARCHAR | Employee full name |
| department | VARCHAR | Organizational department/unit |
| company_group | VARCHAR | Company group/company entity |
| jabatan | VARCHAR | Employee work position/jabatan |
| pangkat | VARCHAR | Employee rank/pangkat |
| role_id | UUID | User role in IDMS |
| auth_source | VARCHAR | LDAP / LOCAL |
| employment_status | VARCHAR | Employee employment status |
| is_active | BOOLEAN | Account status |
| failed_login_attempt | INTEGER | Failed login counter |
| locked_until | TIMESTAMP | Account lock expiration |
| last_login_at | TIMESTAMP | Last login timestamp |
| last_sync_at | TIMESTAMP | Last HRIS synchronization |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

---

## Entity: roles

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| role_name | VARCHAR | Role name |
| description | TEXT | Role description |

---

## Entity: login_audit

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| user_id | UUID | Related user |
| login_time | TIMESTAMP | Login timestamp |
| ip_address | VARCHAR | Client IP address |
| device_info | TEXT | Browser/device information |
| login_status | VARCHAR | SUCCESS / FAILED |
| failure_reason | TEXT | Failure detail |

---