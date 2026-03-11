# AnchorMark WBS / Progress

## What this project is

AnchorMark is a deterministic security maintenance and network trust instrument that produces verifiable truthpacks and append-only receipts for offline validation.

## Current Proven State

- repo surface is incomplete and needs README + docs
- runtime bootstrap directories can be created
- bootstrap path is not yet fully green
- authority key generation is still blocked
- truthpack emission / verify / pledge has not completed end-to-end
- prior green banners were false-green when required artifacts were missing

## Primary Live Blocker

The canonical blocker is authority key generation.

`Ensure-ProducerKey` and related child-process wrappers must pass an actual empty-string operand to `ssh-keygen -N` under Windows PowerShell 5.1. Current wrappers are still failing, causing key generation to fail.

## Next Locked Steps

1. Freeze one authoritative repo-local diagnostic runner proving empty-string `-N` reaches `ssh-keygen` correctly.
2. Re-run bootstrap and prove authority keypair exists under `_runtime_local\keys`.
3. Freeze one authoritative on-disk seal runner.
4. Prove full flow: bootstrap → emit truthpack → verify → pledge → receipts.
5. Add negative vectors for bootstrap, keygen, verify, and pledge failures.
6. Finalize README, spec docs, and usage docs based only on proven behavior.

## Definition of Done

On a clean machine, one authoritative on-disk runner must:

- parse-gate all product scripts
- bootstrap runtime
- create authority keypair
- emit a minimal truthpack
- verify the truthpack
- append a non-empty pledge log entry
- write deterministic receipts and transcripts
- print a single success token only when every required artifact exists and every child step succeeded
