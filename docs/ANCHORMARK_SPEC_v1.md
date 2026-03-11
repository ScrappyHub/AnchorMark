# AnchorMark Specification

AnchorMark defines deterministic security state artifacts.

These artifacts represent:

- network policy
- firewall configuration
- routing state
- device trust

AnchorMark outputs artifacts that can be independently verified.

---

# Artifact Model

Artifacts follow the canonical packet structure.


packet/

manifest.json
packet_id.txt
sha256sums.txt
payload/


---

# Payload Structure

Payload contains security state:


payload/

policy.json
routing.json
firewall.json
devices.json
audit.json


---

# Deterministic Requirements

Artifacts must satisfy:

- canonical JSON encoding
- UTF-8 without BOM
- LF line endings
- deterministic field ordering
- deterministic hashing

---

# Packet ID

Packet ID is derived from the canonical manifest bytes.


packet_id = SHA256(canonical_manifest_bytes)


---

# Receipts

AnchorMark emits append-only receipts.

Receipt example:


{
"schema": "anchormark.receipt.v1",
"event": "policy_compiled",
"timestamp": "ISO8601",
"packet_id": "...",
"receipt_hash": "..."
}


---

# Verification

Verification must:

- recompute packet ID
- verify sha256sums
- verify signatures
- confirm artifact integrity

Verification must **not modify artifacts**.
