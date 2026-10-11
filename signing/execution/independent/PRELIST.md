# Final package independent verification prelist

Author: STARGA Inc.

Frozen inputs: finalpackageaade52f3d0c3ad874ff7c25113f423f487c0579e864cf71ddf1833618ba86918; exactpayloadmanifestd3471291b15b9e3f6d43860d4525729098c628472f7812611c2ae522a1d83965; MINDbindingchecker9f4241c8eaf032cce25e6892cf0f599a87d7b3848e705c398d4554488db2dc14; cryptoverifier1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e; both fullpublickeyfiles identical to independentlycheckeddiagnostic.

Prelisted local and second-host calls:
1. mindc verify --json --require-signed --require-strict-fp --require-deterministic --signer-pubkey FULL_ML87_PUBLIC_KEY --signer-pubkey FULL_SLH_PUBLIC_KEY package.mic3. Require exit0, expected two-leg scheme, valid tracehash and SSA, provenance_authenticated=true. Both explicit pins mandatory; empty environment ensures MIND_EVIDENCE_VERIFY_PUBKEYS absent.
2. MIND map-binding-check with package.mic3 onstdin and exact SHA256(PAYLOAD_SHA256SUMS) lowercasehex+LF onfd3, independently computed on each host. Require exit0 and exact MAP_DIGEST_BINDING=PASS plusLF (confirm observed source output before execution).

Only public artifact/manifest/keys/checker and bounded temporary execution instrumentation transferred. Existing second-host cryptoverifier's exact hash must match before execution. No privatekey access, no signing or compiler rebuild, no GPU, no writes to frozenrepositorypayload. OneCPU,nice19,1GiBAS,25CPU/30wallseconds percall, empty environment. Record actual stdout/stderr/exits/hashes, input hashes and before/after aggregatehostOOM counters. Compare bothhosts' streams byteforbyte. This authenticates and binds packagebytes only; no mathematicalstatuspromotion.
