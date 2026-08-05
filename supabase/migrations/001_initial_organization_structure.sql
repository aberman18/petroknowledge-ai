-- ============================================================
-- PETROKNOWLEDGE AI
-- Migration 001: Initial organization structure
-- ============================================================

-- ------------------------------------------------------------
-- 1. ORGANIZATIONS
-- Represents every company using the platform.
-- The MVP starts with Patagonia Energy S.A.
-- ------------------------------------------------------------

CREATE TABLE public.organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name TEXT NOT NULL,
    legal_name TEXT,
    tax_id TEXT,

    country_code CHAR(2) NOT NULL DEFAULT 'AR',
    industry TEXT NOT NULL DEFAULT 'Oil & Gas',

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT organizations_name_not_empty
        CHECK (char_length(trim(name)) > 0),

    CONSTRAINT organizations_tax_id_unique
        UNIQUE (tax_id)
);


-- ------------------------------------------------------------
-- 2. DEPARTMENTS
-- Represents the internal departments of each organization.
-- ------------------------------------------------------------

CREATE TABLE public.departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL
        REFERENCES public.organizations(id)
        ON DELETE CASCADE,

    name TEXT NOT NULL,
    code TEXT NOT NULL,
    description TEXT,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT departments_name_not_empty
        CHECK (char_length(trim(name)) > 0),

    CONSTRAINT departments_code_not_empty
        CHECK (char_length(trim(code)) > 0),

    CONSTRAINT departments_organization_code_unique
        UNIQUE (organization_id, code)
);


-- ------------------------------------------------------------
-- 3. ROLES
-- Represents the roles available within the platform.
-- Roles may belong to an organization.
-- ------------------------------------------------------------

CREATE TABLE public.roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID
        REFERENCES public.organizations(id)
        ON DELETE CASCADE,

    name TEXT NOT NULL,
    code TEXT NOT NULL,
    description TEXT,

    is_system_role BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT roles_name_not_empty
        CHECK (char_length(trim(name)) > 0),

    CONSTRAINT roles_code_not_empty
        CHECK (char_length(trim(code)) > 0),

    CONSTRAINT roles_organization_code_unique
        UNIQUE NULLS NOT DISTINCT (organization_id, code)
);


-- ------------------------------------------------------------
-- 4. PROFILES
-- Stores the business profile associated with an Auth user.
-- The profile ID matches the user ID from auth.users.
-- ------------------------------------------------------------

CREATE TABLE public.profiles (
    id UUID PRIMARY KEY
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    organization_id UUID
        REFERENCES public.organizations(id)
        ON DELETE SET NULL,

    department_id UUID
        REFERENCES public.departments(id)
        ON DELETE SET NULL,

    full_name TEXT,
    job_title TEXT,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ------------------------------------------------------------
-- 5. USER ROLES
-- Many-to-many relationship between users and roles.
-- ------------------------------------------------------------

CREATE TABLE public.user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE CASCADE,

    role_id UUID NOT NULL
        REFERENCES public.roles(id)
        ON DELETE CASCADE,

    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT user_roles_user_role_unique
        UNIQUE (user_id, role_id)
);


-- ------------------------------------------------------------
-- 6. INDEXES
-- Improve frequently used filters and joins.
-- ------------------------------------------------------------

CREATE INDEX idx_departments_organization_id
    ON public.departments(organization_id);

CREATE INDEX idx_roles_organization_id
    ON public.roles(organization_id);

CREATE INDEX idx_profiles_organization_id
    ON public.profiles(organization_id);

CREATE INDEX idx_profiles_department_id
    ON public.profiles(department_id);

CREATE INDEX idx_user_roles_user_id
    ON public.user_roles(user_id);

CREATE INDEX idx_user_roles_role_id
    ON public.user_roles(role_id);


-- ------------------------------------------------------------
-- 7. ROW LEVEL SECURITY
-- RLS is enabled before the application is allowed to access
-- business data through Supabase APIs.
-- ------------------------------------------------------------

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;


-- ------------------------------------------------------------
-- 8. INITIAL ORGANIZATION
-- ------------------------------------------------------------

INSERT INTO public.organizations (
    name,
    legal_name,
    tax_id,
    country_code,
    industry
)
VALUES (
    'Patagonia Energy',
    'Patagonia Energy S.A.',
    '30-00000000-0',
    'AR',
    'Oil & Gas'
);


-- ------------------------------------------------------------
-- 9. INITIAL DEPARTMENTS
-- This migration preserves the original seed data that was
-- first applied to the remote Supabase database.
-- ------------------------------------------------------------

INSERT INTO public.departments (
    organization_id,
    name,
    code,
    description
)
SELECT
    id,
    department_name,
    department_code,
    department_description
FROM public.organizations
CROSS JOIN (
    VALUES
        (
            'Finanzas',
            'FIN',
            'Administración financiera, contabilidad, impuestos y tesorería'
        ),
        (
            'Compras',
            'PROC',
            'Gestión de proveedores, órdenes de compra y contrataciones'
        ),
        (
            'Legal',
            'LEGAL',
            'Contratos, asuntos regulatorios y cumplimiento legal'
        ),
        (
            'Recursos Humanos',
            'HR',
            'Gestión de empleados, políticas laborales y beneficios'
        ),
        (
            'Operaciones',
            'OPS',
            'Operación de instalaciones, producción y mantenimiento'
        ),
        (
            'Tecnología',
            'IT',
            'Infraestructura, aplicaciones, datos y seguridad tecnológica'
        )
) AS initial_departments (
    department_name,
    department_code,
    department_description
)
WHERE organizations.name = 'Patagonia Energy';


-- ------------------------------------------------------------
-- 10. INITIAL ROLES
-- ------------------------------------------------------------

INSERT INTO public.roles (
    organization_id,
    name,
    code,
    description,
    is_system_role
)
SELECT
    id,
    role_name,
    role_code,
    role_description,
    TRUE
FROM public.organizations
CROSS JOIN (
    VALUES
        (
            'Administrador',
            'ADMIN',
            'Administración completa de la plataforma'
        ),
        (
            'Gerente',
            'MANAGER',
            'Gestión y consulta de información de su departamento'
        ),
        (
            'Supervisor',
            'SUPERVISOR',
            'Supervisión de procesos y usuarios del departamento'
        ),
        (
            'Analista',
            'ANALYST',
            'Consulta y análisis de datos y documentación autorizada'
        ),
        (
            'Auditor',
            'AUDITOR',
            'Acceso de lectura a documentación y registros de auditoría'
        ),
        (
            'Usuario de consulta',
            'VIEWER',
            'Acceso de lectura limitado a contenido autorizado'
        )
) AS initial_roles (
    role_name,
    role_code,
    role_description
)
WHERE organizations.name = 'Patagonia Energy';