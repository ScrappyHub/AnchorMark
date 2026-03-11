# AnchorMark Pipeline Contracts

AnchorMark pipelines must produce deterministic outputs.

---

# Policy Compilation

Input:

- configuration
- allow lists
- deny lists

Output:


policy.json


---

# Routing Compilation

Input:

- network topology
- routing policies

Output:


routing.json


---

# Firewall Compilation

Input:

- allow lists
- deny lists

Output:


firewall.json


---

# Artifact Generation

Combine outputs into a packet artifact.


packet/

manifest.json
packet_id.txt
sha256sums.txt
payload/


---

# Verification

Verification recomputes:

- packet ID
- sha256sums
- artifact integrity
