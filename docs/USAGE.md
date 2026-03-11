# AnchorMark Usage

## Bootstrap

Bootstrap prepares local runtime state and authority key material.

Expected directories:

```text
_runtime_local/
  keys/
  pledges/
  outbox/
  nfl_inbox/
Emit

Emit creates a truthpack under the runtime outbox.

Verify

Verify checks packet integrity and signatures without mutating the packet.

Pledge

Pledge appends a new entry to the append-only pledge log.

Full Run

The canonical goal is a single on-disk runner that performs:

bootstrap
→ emit
→ verify
→ pledge
→ receipts
