/-
  The Justin Sun Prize (孙宇晨奖) — JSP-000301

  **Challenge.lean: the statement of record.**

  This file declares the definitions the problem is phrased with, and the proposition
  `jsp000301Statement`. It proves nothing. `Submission.lean` imports this file, so the proof and the
  statement refer to the *same* constant and the statement cannot drift between them.
  `check.py` type-checks the bridge

      example : jsp000301Statement := disproof_conjecture

  and audits the axioms the submitted proof depends on. A reviewer has only to read this
  file in order to judge *what* has been claimed.
-/


/-- A positive integer `n` is powerful if it can be represented as `a^2 * b^3`
    for positive integers `a` and `b`. -/
def IsPowerful (n : Nat) : Prop :=
  ∃ a b : Nat, a > 0 ∧ b > 0 ∧ n = a^2 * b^3

/-- A natural number `n` is a perfect square if `n = k^2` for some natural number `k`. -/
def IsSquare (n : Nat) : Prop :=
  ∃ k : Nat, n = k^2

/-- **Statement of record for JSP-000301.**

The proposition this development resolves, phrased with the definitions above and
nothing else. -/

def jsp000301Statement : Prop :=
  ¬ (∀ n : Nat, IsPowerful n → IsPowerful (n + 1) → (IsSquare n ∨ IsSquare (n + 1)))
