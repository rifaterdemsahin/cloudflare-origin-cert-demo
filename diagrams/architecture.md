# 🗺️ Architecture diagrams (standalone)

These render on GitHub automatically. Kept separate from the README for reuse in slides/docs.

## Trust boundary

```mermaid
flowchart LR
    U["🧑‍💻 Visitor<br/>Browser"] -->|"HTTPS<br/>public CA cert"| CF["☁️ Cloudflare Edge"]
    CF -->|"HTTPS<br/>Origin CA cert 🔐"| O["🖥️ Origin Server"]

    style U fill:#fef3c7,stroke:#d97706
    style CF fill:#fff7ed,stroke:#f97316,stroke-width:3px
    style O fill:#dbeafe,stroke:#2563eb
```

## Request lifecycle

```mermaid
sequenceDiagram
    participant You as 🧑‍💻 You
    participant CLI as 🖥️ openssl
    participant CF as ☁️ Cloudflare API
    participant Origin as 🖥️ nginx

    You->>CLI: Generate key + CSR
    CLI-->>You: origin.key / origin.csr
    You->>CF: POST /certificates
    CF-->>You: Signed cert (up to 15yr)
    You->>Origin: Install cert + key
    You->>CF: SSL/TLS mode = Full (strict)
    You->>Origin: Verify chain ✅
```

## State machine of a cert

```mermaid
stateDiagram-v2
    [*] --> CSR_Generated
    CSR_Generated --> Requested: POST /certificates
    Requested --> Issued: Cloudflare signs (origin-rsa)
    Issued --> Installed: copied to origin server
    Installed --> Active: SSL mode = Full (strict)
    Active --> Revoked: DELETE /certificates/:id
    Active --> Expired: validity period elapsed
```
