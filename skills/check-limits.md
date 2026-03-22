---
name: check-limits
description: Verify a physics expression in specified limits or boundaries
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Read MAPPING_DICTIONARY §I for Strebel graph structure and §II for the Schwinger-Strebel mapping at boundaries.
3. Parse the user's request: extract the expression and the limit(s) to check. Limits may include:
   - Parameter limits (e.g., lambda -> 0, N -> infinity, g_s -> 0)
   - Moduli space boundaries (e.g., edge lengths l_i -> 0, pinching cycles)
   - Degeneration limits (e.g., tau -> i*infinity, separating/non-separating degenerations)
4. For each limit, analyze the expression:
   a. Substitute the limiting values symbolically and simplify.
   b. Identify leading behavior: finite, divergent (pole order), or vanishing (zero order).
   c. If divergent, classify the divergence (logarithmic, power-law, essential).
   d. If the limit is ambiguous, expand in a small parameter around the limit point.
5. If symbolic analysis is insufficient, detect engine (`sage`, `wolframscript`, `python3` with sympy) and write a numerical verification script:
   a. Evaluate the expression at a sequence of points approaching the limit.
   b. Fit the leading behavior (e.g., log plot for power-law detection).
   c. Execute via Bash and interpret.
6. Report the result for each limit: finite value, divergence type and rate, or vanishing order.
7. Flag any limits where the expression changes character (e.g., finite in one regime, divergent in another).
</process>

<preset>
When the triality preset is active:
- Primary limits to check are moduli space boundary divergences: Strebel edge lengths l_i -> 0.
- These correspond to boundaries of M_{g,n} where the Riemann surface degenerates.
- Strebel degeneration: an edge going to zero length means two zeroes of the Strebel differential collide — the graph topology changes (edge contraction).
- For separating degeneration: surface pinches into two components, check factorization.
- For non-separating degeneration: handle shrinks, genus drops by 1, check residue matching.
- Check integrands from the triality derivation: Schwinger integrands with the V-type mapping l = 1/tau_eff diverge as l -> 0 (tau_eff -> infinity).
- For integer Strebel (discrete moduli), boundary behavior means small integer edge lengths — check l_i = 1 cases carefully.
- Use MAPPING_DICTIONARY §I (Euler characteristic) to verify topology is preserved through limits.
</preset>

<output>
- For each requested limit: the behavior (finite/divergent/vanishing) with the leading coefficient or rate.
- Physical interpretation: what the limit corresponds to in the Strebel/string/gauge picture.
- Whether the expression is integrable near the boundary (relevant for moduli space integrals).
- Warnings if the limit is outside the domain of validity of the expression.
</output>
