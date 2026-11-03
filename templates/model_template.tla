---------------------------- MODULE model_template ----------------------------
EXTENDS Naturals, Sequences, FiniteSets

CONSTANTS Nodes, MaxValue

VARIABLES state, messages, history

TypeOK ==
    /\ state \in [Nodes -> [status: {"INIT", "PREPARE", "COMMITTED", "ABORTED"}, val: 0..MaxValue]]
    /\ messages \subseteq [from: Nodes, to: Nodes, type: {"REQ", "ACK", "COMMIT", "ROLLBACK"}]

Init ==
    /\ state = [n \in Nodes |-> [status |-> "INIT", val |-> 0]]
    /\ messages = {}
    /\ history = <<>>

SafetyInvariant ==
    \A n1, n2 \in Nodes :
        (state[n1].status = "COMMITTED" /\ state[n2].status = "COMMITTED")
            => (state[n1].val = state[n2].val)

Next ==
    \/ \E n \in Nodes : FALSE (* Add state transition steps here *)

Spec == Init /\ [][Next]_<<state, messages, history>>
=============================================================================
