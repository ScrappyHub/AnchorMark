# AnchorMark Threat Model

AnchorMark protects deterministic security state.

Threat categories:

- policy tampering
- artifact forgery
- replay attacks
- configuration drift
- unauthorized policy modification

---

# Integrity Protection

Artifacts are protected using:

- SHA-256 content addressing
- cryptographic signatures
- append-only receipts

---

# Replay Protection

Artifacts include:

- timestamp
- sequence identifiers
- prior references

---

# Verification

Verification is deterministic and reproducible.

Independent verifiers must reach identical results.

---

# Trust Boundary

AnchorMark does not enforce policy.

It produces verifiable policy artifacts.

Enforcement systems may consume these artifacts.
