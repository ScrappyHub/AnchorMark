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
