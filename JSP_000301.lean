/-
  The Justin Sun Prize (孙宇晨奖)
  Problem ID: JSP-000301
  Title: If two consecutive positive integers are powerful, must at least one be a perfect square?
  Mathematical Area: Number theory / Powerful numbers
  Status: Solved (Disproved)
  
  Description:
  A positive integer n is defined as "powerful" (in the sense of Golomb 1970 and Erdős)
  if every prime factor occurs to at least the second power, or equivalently,
  n can be represented in the form a^2 * b^3 with positive integers a and b.
  
  The question asks:
  "If two consecutive positive integers are powerful, must at least one be a perfect square?"
  
  We prove that the answer is NO by formalizing the counterexample:
    n = 12167 = 23^3 = 1^2 * 23^3
    n + 1 = 12168 = 2^3 * 3^2 * 13^2 = 39^2 * 2^3
  Neither 12167 nor 12168 is a perfect square, since:
    110^2 = 12100 < 12167 < 12168 < 12321 = 111^2.
-/

/-- A positive integer `n` is powerful if it can be represented as `a^2 * b^3`
    for positive integers `a` and `b`. -/
def IsPowerful (n : Nat) : Prop :=
  ∃ a b : Nat, a > 0 ∧ b > 0 ∧ n = a^2 * b^3

/-- A natural number `n` is a perfect square if `n = k^2` for some natural number `k`. -/
def IsSquare (n : Nat) : Prop :=
  ∃ k : Nat, n = k^2

/- Algebraic lemmas connecting power syntax with multiplication in pure Lean 4 -/
theorem sq_eq_mul (k : Nat) : k^2 = k * k := by
  change (1 * k) * k = k * k
  rw [Nat.one_mul]

theorem cb_eq_mul (b : Nat) : b^3 = b * b * b := by
  change ((1 * b) * b) * b = b * b * b
  rw [Nat.one_mul]

/-- 12167 is powerful because 12167 = 1^2 * 23^3. -/
theorem powerful_12167 : IsPowerful 12167 := by
  refine ⟨1, 23, by decide, by decide, ?_⟩
  rw [sq_eq_mul, cb_eq_mul]

/-- 12168 is powerful because 12168 = 39^2 * 2^3. -/
theorem powerful_12168 : IsPowerful 12168 := by
  refine ⟨39, 2, by decide, by decide, ?_⟩
  rw [sq_eq_mul, cb_eq_mul]

/-- 12167 is not a perfect square. -/
theorem not_square_12167 : ¬ IsSquare 12167 := by
  intro ⟨k, hk⟩
  rw [sq_eq_mul] at hk
  have : k ≤ 110 ∨ 111 ≤ k := by omega
  rcases this with hle | hge
  · have h1 : k * k ≤ 110 * 110 := Nat.mul_le_mul hle hle
    omega
  · have h1 : 111 * 111 ≤ k * k := Nat.mul_le_mul hge hge
    omega

/-- 12168 is not a perfect square. -/
theorem not_square_12168 : ¬ IsSquare 12168 := by
  intro ⟨k, hk⟩
  rw [sq_eq_mul] at hk
  have : k ≤ 110 ∨ 111 ≤ k := by omega
  rcases this with hle | hge
  · have h1 : k * k ≤ 110 * 110 := Nat.mul_le_mul hle hle
    omega
  · have h1 : 111 * 111 ≤ k * k := Nat.mul_le_mul hge hge
    omega

/-- Main Theorem: There exists a positive integer `n` such that both `n` and `n + 1`
    are powerful, but neither is a perfect square. -/
theorem consecutive_powerful_not_square :
    ∃ n : Nat, IsPowerful n ∧ IsPowerful (n + 1) ∧ ¬ IsSquare n ∧ ¬ IsSquare (n + 1) := by
  refine ⟨12167, powerful_12167, ?_, not_square_12167, ?_⟩
  · show IsPowerful (12167 + 1)
    change IsPowerful 12168
    exact powerful_12168
  · show ¬ IsSquare (12167 + 1)
    change ¬ IsSquare 12168
    exact not_square_12168

/-- Disproof of the universal conjecture:
    It is NOT the case that for all `n`, if `n` and `n + 1` are powerful,
    at least one must be a perfect square. -/
theorem disproof_conjecture :
    ¬ (∀ n : Nat, IsPowerful n → IsPowerful (n + 1) → (IsSquare n ∨ IsSquare (n + 1))) := by
  intro h_univ
  have ⟨n, hp1, hp2, hns1, hns2⟩ := consecutive_powerful_not_square
  have h_or := h_univ n hp1 hp2
  rcases h_or with h1 | h2
  · exact hns1 h1
  · exact hns2 h2
