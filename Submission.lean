/-
  The Justin Sun Prize (孙宇晨奖)
  Problem ID: JSP-000301
  Title: If two consecutive positive integers are powerful, must at least one be a perfect square?
  Mathematical Area: Number theory / Powerful numbers
  Status: Solved (Disproved)

  Description:
  A positive integer n is powerful if every prime factor occurs to at least the second power,
  equivalently n = a^2 * b^3. We prove that the answer to the question is NO by formalizing
  Golomb's counterexample:

      n     = 12167 = 23^3            = 1^2 * 23^3
      n + 1 = 12168 = 2^3 * 3^2 * 13^2 = 39^2 * 2^3

  Neither 12167 nor 12168 is a perfect square, since 110^2 = 12100 < 12167 < 12168 < 12321 = 111^2.

  `isPowerful_sq_mul_cube` proves that numbers of the form a^2 * b^3 are powerful in the sense of
  the statement of record, which is what transfers the two decompositions above to `IsPowerful`.
-/

import Challenge
/-- Numbers of the form `a^2 * b^3` are powerful: a prime dividing the product divides `a` or `b`,
so its square divides the corresponding factor. This is the direction that transfers the classical
witness decompositions to the definition of record above. -/
theorem isPowerful_sq_mul_cube (a b : Nat) : IsPowerful (a ^ 2 * b ^ 3) := by
  intro p hp hdvd
  rcases (hp.dvd_mul.mp hdvd) with h | h
  · have hpa : p ∣ a := hp.dvd_of_dvd_pow h
    exact dvd_mul_of_dvd_left (pow_dvd_pow_of_dvd hpa 2) _
  · have hpb : p ∣ b := hp.dvd_of_dvd_pow h
    exact dvd_mul_of_dvd_right
      (dvd_trans (pow_dvd_pow_of_dvd hpb 2) (pow_dvd_pow b (by norm_num))) _

theorem powerful_12167 : IsPowerful 12167 := by
  have h : (12167 : Nat) = 1 ^ 2 * 23 ^ 3 := by norm_num
  rw [h]; exact isPowerful_sq_mul_cube 1 23

theorem powerful_12168 : IsPowerful 12168 := by
  have h : (12168 : Nat) = 39 ^ 2 * 2 ^ 3 := by norm_num
  rw [h]; exact isPowerful_sq_mul_cube 39 2

/-- The factorisations that exhibit the witnesses, in the form the catalog's review note uses. -/
theorem factorization_12167 : (12167 : Nat) = 23 ^ 3 := by norm_num
theorem factorization_12168 : (12168 : Nat) = 2 ^ 3 * 3 ^ 2 * 13 ^ 2 := by norm_num

theorem not_square_12167 : ¬ IsSquare 12167 := by
  rintro ⟨k, hk⟩
  have hk'' : k * k = 12167 := hk.symm
  have hb : k ≤ 110 ∨ 111 ≤ k := by omega
  rcases hb with h | h
  · have := Nat.mul_le_mul h h; nlinarith
  · have := Nat.mul_le_mul h h; nlinarith

theorem not_square_12168 : ¬ IsSquare 12168 := by
  rintro ⟨k, hk⟩
  have hk'' : k * k = 12168 := hk.symm
  have hb : k ≤ 110 ∨ 111 ≤ k := by omega
  rcases hb with h | h
  · have := Nat.mul_le_mul h h; nlinarith
  · have := Nat.mul_le_mul h h; nlinarith

theorem consecutive_powerful_not_square :
    ∃ n : Nat, IsPowerful n ∧ IsPowerful (n + 1) ∧ ¬ IsSquare n ∧ ¬ IsSquare (n + 1) := by
  refine ⟨12167, powerful_12167, ?_, not_square_12167, ?_⟩
  · show IsPowerful (12167 + 1); exact powerful_12168
  · show ¬ IsSquare (12167 + 1); exact not_square_12168

theorem disproof_conjecture :
    ¬ (∀ n : Nat, IsPowerful n → IsPowerful (n + 1) → (IsSquare n ∨ IsSquare (n + 1))) := by
  intro h
  obtain ⟨n, h1, h2, h3, h4⟩ := consecutive_powerful_not_square
  rcases h n h1 h2 with h5 | h5
  · exact h3 h5
  · exact h4 h5

#print axioms disproof_conjecture
