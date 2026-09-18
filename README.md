# JSP-000301 — Lean 4 formalization

A machine-checked Lean 4 disproof of the following question:

> *If two consecutive positive integers are powerful, must at least one be a perfect square?*

Catalog entry JSP-000301 (number theory / powerful numbers). The entry records the question as
solved, disproved by Solomon W. Golomb in 1970 with the consecutive pair

```
12167 = 23^3 = 1^2 * 23^3
12168 = 2^3 * 3^2 * 13^2 = 39^2 * 2^3
```

Neither is a perfect square, since `110^2 = 12100 < 12167 < 12168 < 12321 = 111^2`.

This repository contains the Lean 4 formalization of that disproof. The repository is
self-contained apart from Mathlib; see [Build and check](#build-and-check).

## Statement of record — `Challenge.lean`

`Challenge.lean` declares the definitions the problem is phrased with and the proposition
`jsp000301Statement`. It proves nothing, so a reviewer has only to read that one file to judge *what* has
been claimed.

```lean
def IsPowerful (n : Nat) : Prop := ∀ p : Nat, p.Prime → p ∣ n → p ^ 2 ∣ n

def jsp000301Statement : Prop :=
  ¬ (∀ n : Nat, IsPowerful n → IsPowerful (n + 1) → (IsSquare n ∨ IsSquare (n + 1)))
```

`IsPowerful` is the definition recorded in the catalog entry's review note — every prime factor occurs
to at least the second power — with `IsSquare` taken from Mathlib.

## Proof — `Submission.lean`

`Submission.lean` imports `Challenge.lean`, so the proof and the statement refer to the *same*
`jsp000301Statement` constant and cannot drift apart. The top-level result is

```lean
disproof_conjecture
```

The witnesses are Golomb's pair `12167 = 23^3` and `12168 = 2^3 * 3^2 * 13^2`. Each is powerful because
it has the form `a^2 * b^3` (`1^2 * 23^3` and `39^2 * 2^3`), and the general lemma
`isPowerful_sq_mul_cube` proves that every number of that form is powerful in the sense of the statement
of record; `factorization_12167` and `factorization_12168` record the factorisations the entry's review
note uses. Neither witness is a perfect square, since `110^2 = 12100 < 12167 < 12168 < 12321 = 111^2`.

The file contains no `sorry`, no `admit`, no `axiom`, no `opaque`, no `unsafe` and no `native_decide`.
`check.py` type-checks the bridge

```
example : jsp000301Statement := disproof_conjecture
```

and re-runs the axiom audit.

## Build and check

```sh
lake exe cache get   # Mathlib oleans
lake build
python3 check.py
```

Toolchain: `leanprover/lean4:v4.34.0` (commit `293d5d0c0c3f3dded4688b3ccd6a33939ac5102b`); Mathlib is
pinned to `5ed2965256430c3649e86755f9576b54eca72435` (tag `v4.34.0`) in `lake-manifest.json`.

`check.py` runs the build, rejects `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, `partial` and
`native_decide` in `Submission.lean`, type-checks the bridge above — which can only succeed if the
submission proves exactly the proposition that `Challenge.lean` states — and audits
`#print axioms disproof_conjecture`, which reports `[propext, Classical.choice, Quot.sound]`, the three
axioms of Lean's logic and nothing else. The same audit runs in CI on every push
(`.github/workflows/lean_action_ci.yml`).

## Repository layout

| File | Role |
| --- | --- |
| `Challenge.lean` | Statement of record: definitions and the proposition, no proof |
| `Submission.lean` | The proof; imports `Challenge.lean` |
| `check.py` | Build, forbidden-token scan, bridge type-check, axiom audit |
| `.github/workflows/lean_action_ci.yml` | CI: `lean-action` followed by `check.py` |
| `lakefile.toml`, `lake-manifest.json`, `lean-toolchain` | Build configuration and pinned dependencies |

## Attribution

- **Mathematical result.** Solomon W. Golomb, *Powerful numbers*, American Mathematical Monthly 77(8)
  (1970), 848–852, as recorded in the catalog entry. This repository claims no credit for the
  mathematical solution, which is already attributed in the entry.
- **Lean 4 formalization.** Qin Zhao (GitHub: [Drag0ndddd1118](https://github.com/Drag0ndddd1118)),
  who owns this repository. The proof script was drafted with AI assistance; the account holder is
  responsible for its content and performed the build and the axiom audit.

## License

Apache License 2.0 — see [LICENSE](LICENSE).
