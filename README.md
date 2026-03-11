# AnchorMark

AnchorMark is the security maintenance and network trust anchor for the Governed Operating System (GOS).

It produces deterministic security state artifacts that describe:

- network policy
- device trust
- firewall configuration
- routing rules
- audit state

AnchorMark outputs verifiable **truthpacks** and **receipts** that can be independently validated offline.

These artifacts allow any system to replay and verify the security posture of a device or network.

---

# Purpose

AnchorMark exists to make security state **deterministic, verifiable, and replayable**.

Instead of opaque security tools or dashboards, AnchorMark produces:

- canonical policy artifacts
- cryptographically signed security state
- append-only receipts
- deterministic verification output

These outputs allow independent systems to verify the same results.

---

# Core Responsibilities

AnchorMark provides the following functions:

### Security Policy Compilation

Compile deterministic outputs for:

- firewall rules
- routing tables
- VPN configuration
- allow lists
- deny lists

### Network Trust Anchor

Define the authoritative network trust state.

### Device Security State

Accept device attestations and produce verifiable security records.

### Audit Engine

Record security activity in append-only receipts.

### Artifact Generation

Produce verifiable security artifacts.

---

# Truthpack Artifacts

AnchorMark produces **truthpacks**.

A truthpack is a deterministic artifact that represents a security state.

Example contents:


manifest.json
packet_id.txt
sha256sums.txt
payload/
policy.json
routing.json
firewall.json
audit.json


These artifacts follow the canonical packet structure used across the ecosystem.

---

# Integration

AnchorMark integrates with:

### WatchTower

Device attestation and telemetry verification.

### NeverLost (NFL)

Witness duplication and artifact verification.

### Packet Constitution

Canonical packet format.

---

# Security Architecture

AnchorMark implements a deterministic security model.

Security state is represented as:


security state
→ canonical artifact
→ cryptographic hash
→ signature
→ receipt


This ensures security state can be independently verified.

---

# Runtime Layout

AnchorMark runtime directories:


_runtime_local/

keys/
pledges/
outbox/
nfl_inbox/


Purpose:

| Directory | Purpose |
|--------|--------|
| keys | signing keys |
| pledges | append-only security pledge log |
| outbox | produced artifacts |
| nfl_inbox | witness artifacts |

---

# Pipeline

AnchorMark pipeline:


bootstrap
→ policy compilation
→ artifact creation
→ verification
→ receipt emission


Each step produces deterministic output.

---

# Security Model

AnchorMark is designed to support:

- offline verification
- deterministic security state
- independent validation
- replayable security audit

---

# Future Expansion

AnchorMark provides the infrastructure required for:

- intrusion detection
- intrusion prevention
- distributed network policy verification
- security artifact distribution

---

# License

TBD
