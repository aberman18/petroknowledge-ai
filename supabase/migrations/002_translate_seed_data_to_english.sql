-- ============================================================
-- PETROKNOWLEDGE AI
-- Migration 002: Translate initial seed data to English
-- ============================================================

BEGIN;

UPDATE public.departments
SET
    name = 'Finance',
    description = 'Financial administration, accounting, tax management, and treasury operations',
    updated_at = NOW()
WHERE code = 'FIN';

UPDATE public.departments
SET
    name = 'Procurement',
    description = 'Vendor management, purchase orders, sourcing, and contracting processes',
    updated_at = NOW()
WHERE code = 'PROC';

UPDATE public.departments
SET
    name = 'Legal',
    description = 'Contract management, regulatory affairs, legal operations, and compliance',
    updated_at = NOW()
WHERE code = 'LEGAL';

UPDATE public.departments
SET
    name = 'Human Resources',
    description = 'Employee management, labor policies, benefits, and organizational development',
    updated_at = NOW()
WHERE code = 'HR';

UPDATE public.departments
SET
    name = 'Operations',
    description = 'Facility operations, oil and gas production, maintenance, and field activities',
    updated_at = NOW()
WHERE code = 'OPS';

UPDATE public.departments
SET
    name = 'Technology',
    description = 'Technology infrastructure, business applications, data, AI, and cybersecurity',
    updated_at = NOW()
WHERE code = 'IT';


UPDATE public.roles
SET
    name = 'Administrator',
    description = 'Full administration of the platform, users, permissions, and system configuration',
    updated_at = NOW()
WHERE code = 'ADMIN';

UPDATE public.roles
SET
    name = 'Manager',
    description = 'Management and access to authorized information within the assigned department',
    updated_at = NOW()
WHERE code = 'MANAGER';

UPDATE public.roles
SET
    name = 'Supervisor',
    description = 'Supervision of departmental processes, content, and authorized users',
    updated_at = NOW()
WHERE code = 'SUPERVISOR';

UPDATE public.roles
SET
    name = 'Analyst',
    description = 'Analysis and consultation of authorized business data and documentation',
    updated_at = NOW()
WHERE code = 'ANALYST';

UPDATE public.roles
SET
    name = 'Auditor',
    description = 'Read-only access to authorized documentation, controls, and audit records',
    updated_at = NOW()
WHERE code = 'AUDITOR';

UPDATE public.roles
SET
    name = 'Viewer',
    description = 'Limited read-only access to authorized content',
    updated_at = NOW()
WHERE code = 'VIEWER';

COMMIT;