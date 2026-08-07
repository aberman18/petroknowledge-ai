# PetroKnowledge AI — Project Vision

## 1. Executive Summary

PetroKnowledge AI is a secure enterprise knowledge platform designed for energy and oil & gas organizations.

The platform enables employees to search, understand, and interact with internal company knowledge using natural language while maintaining strict access controls, traceability, document versioning, and source-grounded AI responses.

Rather than functioning as a generic chatbot, PetroKnowledge AI combines structured enterprise data, internal documentation, semantic search, Retrieval-Augmented Generation (RAG), and Large Language Models (LLMs) to provide reliable and auditable answers.

The initial implementation is designed around a fictional Argentine oil & gas company called Patagonia Energy S.A.

---

## 2. Business Problem

Large energy companies generate and maintain significant volumes of information across different systems and departments.

Examples include:

- Financial policies
- Tax regulations
- Accounting procedures
- Procurement manuals
- Contracts
- Safety procedures
- Technical manuals
- Human Resources policies
- Compliance documentation
- Regulatory documentation

Employees often spend significant time locating the correct document, identifying the latest version, interpreting its contents, and verifying whether they are authorized to access it.

Traditional keyword-based search systems also struggle when users ask questions using terminology that differs from the wording contained in the documents.

PetroKnowledge AI aims to reduce this friction by providing secure semantic access to enterprise knowledge.

---

## 3. Product Goal

The goal of PetroKnowledge AI is to allow an authorized employee to ask a natural-language question and receive a reliable answer based on approved enterprise information.

Example:

User question:

"Who can approve a purchase above ARS 50 million?"

PetroKnowledge AI should:

1. Identify the user's organization and permissions.
2. Search only authorized information.
3. Retrieve the most relevant document sections.
4. Verify document status and version.
5. Provide the relevant context to the LLM.
6. Generate a clear answer.
7. Cite the supporting source.
8. Record the interaction for auditing purposes.

---

## 4. Target Organization

The initial organization is:

**Patagonia Energy S.A.**

Industry:

**Oil & Gas / Energy**

Country:

**Argentina**

Initial departments:

- Finance
- Procurement
- Legal
- Human Resources
- Operations
- Technology

The architecture will support multiple organizations in the future.

---

## 5. Target Users

### Administrator

Responsible for platform configuration, organizations, users, roles, permissions, and system-level settings.

### Manager

Responsible for departmental knowledge, authorized users, and business processes.

### Supervisor

Can supervise content and users within an authorized department.

### Analyst

Uses PetroKnowledge AI to research policies, procedures, business data, and internal knowledge.

### Auditor

Requires traceable read access to documents, historical versions, AI interactions, and audit records.

### Viewer

Has limited read-only access to approved knowledge.

---

## 6. Core Capabilities

### Enterprise Document Management

The platform will support enterprise documents such as:

- PDF
- Word
- Excel
- Policies
- Procedures
- Contracts
- Manuals
- Regulations

Documents will support metadata, ownership, departments, versioning, status, and access permissions.

### Document Versioning

Documents may change over time.

PetroKnowledge AI will preserve previous versions while identifying the currently active version.

This allows both current operational queries and historical audit queries.

### Change Detection

Uploaded documents will have a content hash.

When a new version is uploaded, the platform can determine whether the content actually changed before reprocessing it.

### Document Processing

Documents will be transformed into smaller semantic units called chunks.

Each chunk will maintain a relationship with:

- its source document
- document version
- organization
- department
- metadata
- permissions

### Embeddings

Document chunks will be transformed into numerical vector representations using an embedding model.

These vectors allow PetroKnowledge AI to compare semantic meaning rather than relying only on exact keyword matches.

### Vector Search

Embeddings will initially be stored using PostgreSQL and pgvector.

The system will retrieve semantically similar document chunks based on the user's question.

### Retrieval-Augmented Generation (RAG)

PetroKnowledge AI will combine retrieved enterprise knowledge with a Large Language Model.

The LLM will generate responses using the retrieved information as context.

### Source Attribution

Responses should include references to the documents used to generate the answer.

### Metadata Filtering

Retrieval may be restricted by attributes such as:

- organization
- department
- document type
- status
- effective date
- language
- jurisdiction
- access level

### Hybrid Search

Future versions will combine:

- semantic vector search
- traditional keyword search

This is particularly important for exact identifiers such as:

- regulation numbers
- contract numbers
- invoice numbers
- technical codes

### Reranking

Retrieved results may be reevaluated by a reranking model to improve the quality of context passed to the LLM.

### Auditability

The platform will maintain records of important activities including:

- document uploads
- document updates
- user queries
- retrieved sources
- generated responses
- model usage
- permission-sensitive actions

---

## 7. Security Principles

PetroKnowledge AI is designed using enterprise security principles.

The platform will implement:

- authentication
- role-based access control
- row-level security
- tenant isolation
- department-level access
- secure secret management
- audit logging
- source-based AI responses

A user should never retrieve information they are not authorized to access.

Security restrictions must be applied before information is sent to the LLM.

---

## 8. Multilingual Design

The platform will initially support:

- English
- Spanish

Technical implementation, source code, database objects, APIs, and public engineering documentation will use English.

Enterprise documents may exist in multiple languages.

Semantic retrieval should allow users to search across multilingual content.

---

## 9. Initial Technology Stack

### Backend

Python  
FastAPI

### Database

PostgreSQL  
Supabase

### Vector Storage

pgvector

### Authentication

Supabase Auth

### Authorization

PostgreSQL Row-Level Security

### Document Storage

Supabase Storage

### AI / RAG

Embedding models  
Large Language Models  
LangChain or equivalent orchestration tools where appropriate

### Development

Git  
GitHub  
Visual Studio Code

### Containerization

Docker

### Future Cloud Deployment

Amazon Web Services

Potential AWS services include:

- Amazon Bedrock
- Amazon S3
- AWS Lambda
- Amazon API Gateway
- Amazon Cognito
- AWS Secrets Manager
- Amazon CloudWatch
- AWS IAM

### Infrastructure as Code

Terraform

---

## 10. Initial Use Case

The first business domain implemented will be:

**Finance & Tax**

Example knowledge sources may include:

- Internal financial procedures
- Payment policies
- Procurement procedures
- Accounting policies
- Tax documentation
- Argentine regulatory documentation
- ARCA documentation
- Invoice control procedures

Future domains will include Legal, HR, Operations, Procurement, and Technology.

---

## 11. Success Criteria

The MVP will be considered successful when an authorized user can:

1. Authenticate securely.
2. Access only authorized organizational knowledge.
3. Upload an enterprise document.
4. Process the document into chunks.
5. Generate embeddings.
6. Store embeddings using pgvector.
7. Ask a natural-language question.
8. Retrieve relevant document sections.
9. Generate a source-grounded response.
10. See the supporting sources.
11. Preserve an audit record of the interaction.

---

## 12. Long-Term Vision

PetroKnowledge AI may evolve into a reusable enterprise AI knowledge platform capable of integrating with systems such as:

- SharePoint
- Google Drive
- Microsoft OneDrive
- Confluence
- SAP
- ERP platforms
- CRM platforms
- Data warehouses
- enterprise APIs

Future capabilities may include:

- automated document synchronization
- AI agents
- structured database querying
- enterprise workflows
- model evaluation
- RAG quality monitoring
- multi-model AI routing
- cost monitoring
- advanced compliance controls