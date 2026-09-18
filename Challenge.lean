/-
  The Justin Sun Prize (孙宇晨奖) — JSP-000301

  **Challenge.lean: the statement of record.**

  This file declares the definitions the problem is phrased with, and the proposition
  `jsp000301Statement`. It proves nothing. `Submission.lean` imports this file, so the proof and
  the statement refer to the *same* constant and the statement cannot drift between them.
  `check.py` type-checks the bridge

      example : jsp000301Statement := disproof_conjecture

  and audits the axioms the submitted proof depends on. A reviewer has only to read this
  file in order to judge *what* has been claimed.
-/

import Mathlib

/-- A positive integer `n` is powerful if every prime factor occurs to at least the second power:
for every prime `p` dividing `n`, also `p ^ 2` divides `n`. This is the definition recorded in the
catalog entry's review note ("A powerful number has exponent at least two in every prime factor").
It is equivalent to the classical representation `n = a ^ 2 * b ^ 3`; the direction needed below is
proved as `isPowerful_sq_mul_cube` in `Submission.lean`. -/
def IsPowerful (n : Nat) : Prop := ∀ p : Nat, p.Prime → p ∣ n → p ^ 2 ∣ n

/-- **Statement of record for JSP-000301.**

The exact yes/no question of the entry: if two consecutive positive integers are powerful, must at
least one of them be a perfect square? `IsSquare` is Mathlib's. -/
def jsp000301Statement : Prop :=
  ¬ (∀ n : Nat, IsPowerful n → IsPowerful (n + 1) → (IsSquare n ∨ IsSquare (n + 1)))
