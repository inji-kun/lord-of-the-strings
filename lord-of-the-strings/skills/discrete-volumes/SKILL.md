---
name: discrete-volumes
description: Compute discrete volumes N_{g,s}(P_1,...,P_s) — weighted counts of integer points in moduli space
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Read MAPPING_DICTIONARY §IV for the Kontsevich-Penner model and intersection number framework.
3. Parse the user's request: extract (g,s) and the perimeter values P_1,...,P_s (positive integers with sum even).
4. Validate inputs:
   a. Check stability: 2g - 2 + s > 0.
   b. Check parity: sum P_I must be even (each edge contributes to two face perimeters).
   c. Check positivity: all P_I >= 1.
5. For small (g,s) — specifically (0,3), (1,1), (0,4), (1,2) — compute directly in-prompt using known closed forms:
   a. N_{0,3}(P_1,P_2,P_3) = 1/2 if triangle inequality holds and sum is even, 0 otherwise (modulo refinements).
   b. N_{1,1}(P) involves a sum over integer partitions of P into edge lengths of genus-1 one-face graphs.
6. For general (g,s), detect symbolic engine (`sage`, `wolframscript`, `python3` with sympy) and write a script implementing the lattice-point recursion:
   a. Use the Norbury-style recursion: express N_{g,s}(P) in terms of lower (g',s') volumes via cut-and-join operations on ribbon graphs.
   b. Include the boundary terms from graph degenerations.
   c. Track automorphism factors carefully.
7. Execute the script via Bash.
8. Interpret results: present N_{g,s}(P_1,...,P_s) as a polynomial in P_I (it is piecewise polynomial by Ehrhart theory).
9. If requested, verify against the Kontsevich-Penner generating function or against intersection numbers via the discrete-to-continuous limit.
</process>

<preset>
When the triality preset is active:
- Use the specific discrete Mirzakhani-like recursion from Giacchetto-Maity-Mazenc (2510.17728).
- This recursion relates N_{g,s}(P_1,...,P_s) to volumes with fewer punctures or lower genus, analogous to the Mirzakhani recursion for Weil-Petersson volumes.
- The Kontsevich-Penner framework from 1512.09309 provides the matrix model whose Feynman expansion generates these discrete volumes.
- Norbury (0801.4590) established the lattice-point counting technology: N_{g,s} counts the number of integer-edge-length ribbon graphs of genus g with s faces of perimeters P_I, weighted by 1/|Aut|.
- Parity constraint from MAPPING_DICTIONARY §IV: sum P_I even, individual P_I can be odd.
- Connection to topological recursion: the generating function of N_{g,s} is computed by the TR correlators W^{(g)}_s on the Gaussian spectral curve (Convention A).
- For genus 1: cross-check against explicit torus graph enumeration from the strebel-solver skill.
</preset>

<output>
- The discrete volume N_{g,s}(P_1,...,P_s) as a number or piecewise-polynomial expression.
- The individual ribbon graph contributions (graph type, edge lengths, automorphism factor) for small cases.
- Comparison to the continuous Weil-Petersson volume V_{g,s} in the large-P limit if relevant.
- Verification against intersection numbers: N_{g,s} ~ sum <tau_{d_1}...tau_{d_s}>_g * prod P_I^{2d_I} + lower terms.
</output>
