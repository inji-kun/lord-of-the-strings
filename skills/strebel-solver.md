---
name: strebel-solver
description: Solve for Strebel differential data given graph topology and face perimeters
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Read MAPPING_DICTIONARY §I for Strebel graph structure, §II for Schwinger-Strebel mapping.
3. Parse the user's input: graph topology (genus g, number of faces n, edge list or adjacency data) and perimeters P_I for each face.
4. Validate topology:
   a. Check Euler relation: V - E + n = 2 - 2g. If it fails, report the inconsistency.
   b. For trivalent graphs: verify E = 6g - 6 + 3n and V = 4g - 4 + 2n.
   c. Each edge borders exactly two faces (possibly the same face).
5. Build the face-edge incidence matrix A_{Ii}: entry is 1 (or 2 if both sides of edge i border face I).
6. Set up the perimeter constraint system: A * l = P, where l_i > 0 are edge lengths.
7. Solve:
   a. For real Strebel: the system is linear with positivity constraints. Find the solution space (it may be a polytope). Report dimension = E - rank(A).
   b. For integer Strebel: enumerate all solutions l_i in Z_+ satisfying A * l = P. Use constraint propagation or backtracking for small cases.
8. If the user provides a specific graph (e.g., by name like "theta graph", "Mercedes", "prism"), look it up or construct its combinatorial data.
9. Present results: edge lengths (or solution space), the Strebel differential data, and the corresponding point in M_{g,n}.
</process>

<preset>
When the triality preset is active:
- Focus on genus-one (torus) graphs: V - E + n = 0.
- Integer Strebel lengths: l_i = n_i in Z_+, where n_i counts Wick contractions.
- Parity constraint: sum of all P_I must be even (each edge contributes to two face perimeters).
- For covering-map / Belyi interpretation: integer lengths define a branched covering of CP^1. The permutation data (sigma_0, sigma_1, sigma_infty) encodes the covering — relate to Hurwitz theory.
- Elliptic/modular geometry for g=1: the Strebel differential on a torus with modular parameter tau determines tau as a function of the edge lengths. Use theta functions and Weierstrass-P when computing the differential explicitly.
- Reference 2212.05999 §5 for the Strebel construction, 0803.2681 for the integer Strebel prescription.
- For small (g,n), enumerate all trivalent ribbon graphs up to isomorphism and solve for each.
</preset>

<output>
- Edge lengths l_i satisfying the perimeter constraints (exact values or parametric family).
- For integer Strebel: the complete list of valid integer assignments, with multiplicity/automorphism factors.
- The dimension of the solution space (should equal dim M_{g,n} = 3g - 3 + n for generic graphs).
- If g=1: the modular parameter tau corresponding to each integer Strebel solution.
- Covering-map permutation data if applicable.
</output>
