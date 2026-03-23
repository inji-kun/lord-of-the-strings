---
name: formalize-lemma
description: Translate a LaTeX equation into a Lean 4 theorem statement and verify via lake build
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Read the LaTeX equation from the user's input or from a specified .tex file.
3. Identify the mathematical content: is it an identity, inequality, bound, parity statement, recursion relation, or structural claim?
4. Translate to a Lean 4 `theorem` statement using mathlib4 conventions:
   a. Map LaTeX symbols to mathlib4 types: N -> Nat, Z -> Int, R -> Real, sums -> Finset.sum, etc.
   b. Express hypotheses as explicit `(h : ...)` parameters.
   c. Use `by` tactic blocks for the proof skeleton (sorry for initial attempt).
5. Write the .lean file to a temporary location (e.g., `scratch/FormalCheck.lean`).
6. Run `lake build` via Bash to check the statement compiles.
7. If error: read the compiler output, diagnose the issue, fix the .lean file, and retry.
   - Common fixes: missing imports, wrong universe levels, type mismatches, missing coercions.
   - Max 5 iterations.
8. If success after any iteration: report that the theorem statement type-checks. The `sorry` marks where a proof is still needed.
9. After 5 failures: report the best attempt, the last compiler error, and suggest:
   - Check mathlib4 version compatibility.
   - Check if required definitions exist in mathlib4.
   - Decompose into smaller lemmas that are individually formalizable.

SCOPE LIMITATION: Lean 4 formalization is realistic for combinatorial and algebraic identities
(parity constraints, Euler characteristic computations, recursion relations, automorphism factor
bookkeeping, finite sum identities). It is NOT realistic for:
- Strebel existence/uniqueness theorems (requires complex analysis on Riemann surfaces)
- Moduli space geometry (requires orbifold/stack theory not in mathlib4)
- psu(1,1|2)_1 representation theory (requires Lie superalgebra machinery)
- Convergence of matrix integrals (requires non-trivial measure theory)
If the user's equation falls in the unrealistic category, explain why and suggest what CAN be formalized (e.g., the combinatorial shadow of the statement).
</process>

<preset>
When the triality preset is active:
- Focus on formalizing identities from the Strebel/discrete-volume/topological-recursion pipeline:
  - Parity: sum of face perimeters is even (each edge contributes to exactly two faces).
  - Euler characteristic: V - E + F = 2 - 2g for ribbon graphs.
  - Trivalent constraint: 2E = 3V for trivalent graphs.
  - Perimeter constraints: A * l = P where A is the face-edge incidence matrix.
  - Automorphism factor identities: |Aut(Gamma)| divides into the symmetry factor correctly.
  - Recursion bookkeeping: the cut-and-join terms in Mirzakhani-style recursion sum correctly.
- Use `Mathlib.Combinatorics.SimpleGraph`, `Mathlib.Topology.Basic`, `Mathlib.Analysis.SpecificLimits` as starting imports.
- Reference MAPPING_DICTIONARY section IV for the discrete volume identities to formalize.
</preset>

<output>
- The Lean 4 file with the theorem statement (and `sorry` proof placeholder).
- Compilation status: success or last error message.
- A plain-language explanation of what the formal statement says.
- If applicable: suggestions for completing the proof (which tactics or lemmas to use).
</output>
