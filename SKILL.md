---
name: spec-weaver
description: >-
  [WHAT IT DOES]: Formally specifies and mathematically proves concurrent, distributed, and state-machine algorithms
  using TLA+, PlusCal, or automated state-space exploration before implementation.
  [WHEN TO USE]: Use when the user designs financial ledgers, concurrent transaction logic, distributed locks,
  consensus protocols, or complex asynchronous workflows where race conditions, deadlocks, or state corruption are critical.
  [WHEN NOT TO USE]: Do NOT use for basic CRUD operations, static web forms, or synchronous single-threaded UI rendering.
---

# Spec Weaver: Mathematical Formal Verification Engine

```
  +--------------------------------------------------------------------------+
  |                                SPEC WEAVER                               |
  |             Mathematical Invariant & State-Space Proof Engine            |
  +--------------------------------------------------------------------------+
       |                                                    |
       v                                                    v
  [State Invariants]                                [System Transitions]
   - Type Invariants                                 - Next State Relations
   - Safety: [](NoNegativeBalance)                   - Message Dropping
   - Liveness: <>(TerminalState)                     - Concurrency Interleaving
       |                                                    |
       +-------------------------+--------------------------+
                                 |
                                 v
                     [BFS Model Checker Loop]
                     - Cycle Detection
                     - Invariant Guard Evaluation
                     - State-Space Hash Deduplication
                                 |
                +----------------+----------------+
                |                                 |
          [Passed (100%)]                   [Counterexample]
                v                                 v
      [Generate Code Scaffold]         [Emit Minimal Error Trace]
      - Pre/Post Condition Guards      - Pinpoint Interleaving Bug
      - Mathematical Certificate       - Auto-Propose Invariant Fix
```

---

## 1. When to Activate

Trigger `spec-weaver` whenever the user's task involves:
- **Financial & Ledger Systems:** Account balances, currency transfers, multi-party escrow, double-spend prevention.
- **Distributed Concurrency:** Two-phase commits (2PC), leader elections (Raft/Paxos variants), distributed mutexes.
- **Complex Asynchronous Lifecycles:** Stateful job runners, saga orchestrators, retry-with-cancellation pipelines.
- **Elusive Heisenbugs:** Flaky race conditions or deadlock bug reports that are difficult to reproduce with standard unit tests.

---

## 2. Mathematical Formalization Runbook

### Step 1: Elicit Invariants
Before generating code or specs, list the core invariants:
1. **Safety Properties ($\square P$):** "Bad things never happen."
   * *Example:* `\A a \in Accounts : balance[a] >= 0`
   * *Example:* `Cardinality(ActiveLeaders) <= 1`
2. **Liveness Properties ($\diamondsuit P$):** "Good things eventually happen."
   * *Example:* `RequestIssued ~> RequestResolved`
3. **Type Correctness ($TypeOK$):** State bounds, enum domains, set memberships.

### Step 2: Run Automated State-Space Exploration
Execute the Python verification engine to prove the algorithm across all possible interleaved transitions:
```bash
python scripts/verify_invariants.py --demo
```
Or define custom states in Python and run:
```python
from scripts.verify_invariants import StateSpaceVerifier

verifier = StateSpaceVerifier(initial_state={"status": "IDLE", "lock": False})
verifier.add_safety_invariant("ValidStatus", lambda s: s["status"] in {"IDLE", "RUNNING", "DONE"})
verifier.add_transition("Start", lambda s: [{"status": "RUNNING", "lock": True}] if not s["lock"] else [])
is_valid, err, trace = verifier.verify(check_deadlocks=True)
```

### Step 3: Handle Counterexamples
If the model checker finds an invariant violation:
1. Read the minimal state trace emitted by `print_counterexample()`.
2. Locate the specific transition where mutual exclusion was lost or a race occurred.
3. Propose a refined guard (e.g. Compare-And-Swap, atomic transaction boundary, or sequence token).

### Step 4: Export Verified Production Code
Translate the verified transitions into the target language (Go, Rust, TypeScript, Python) with runtime invariant assertion checks embedded directly into the code.

---

## 3. Reference Files
- [verify_invariants.py](./scripts/verify_invariants.py): The industrial-grade BFS state-space model checker.
- [model_template.tla](./templates/model_template.tla): Standard TLA+/PlusCal formal model template.
