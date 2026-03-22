---
name: series-expand
description: Expand any matrix model or field theory in a specified parameter (1/N, coupling, genus)
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Read MAPPING_DICTIONARY §IV for Kontsevich matrix integral and intersection numbers.
3. Parse the user's request: identify the expression to expand, the expansion parameter (1/N, coupling g_s, genus g, Kontsevich times xi_k), and the desired order.
4. Detect symbolic engine by probing in order:
   - `sage --version` (SageMath — preferred)
   - `wolframscript -code '1+1'` (Mathematica)
   - `python3 -c "import sympy"` (SymPy fallback)
5. Write a computation script to a temp file implementing:
   a. Define the expression or generating function (matrix integral, free energy, resolvent, etc.).
   b. Set up the expansion parameter and order.
   c. For genus expansion: collect terms by powers of N^{2-2g} or g_s^{2g-2+n}.
   d. For coupling expansion: Taylor-expand and collect.
   e. Simplify coefficients. Express in terms of intersection numbers or Kontsevich times where appropriate.
   f. Print term-by-term results.
6. Execute the script via Bash.
7. Interpret the output: present the expansion with clear labeling of each order. Identify the leading and subleading behavior.
8. Cross-check: if low-order terms are known (e.g., W^{(0)}_1 disk, W^{(0)}_2 cylinder), verify they match.
</process>

<preset>
When the triality preset is active:
- Default expansion is the Kontsevich-Penner 1/N expansion: F = sum_{g,s} N^{2-2g} alpha^{2-2g-s} F^{(g,s)}_K.
- Spectral curve from preset Convention A: x = e^lambda + e^{-lambda}, y = e^lambda.
- Kontsevich times: xi_k = (1/N) sum_i (2k)!/lambda_i^{2k+1}.
- Use conventions from Giacchetto-Lewanski (2410.13273).
- For intersection numbers, use the Laplace transform relation from MAPPING_DICTIONARY §IV:
  <tau_{d_1}...tau_{d_s}>_g via prod (2d_I)!/lambda_I^{2d_I+1}.
- When expanding resolvents, use Convention B (y_B = (e^lambda - e^{-lambda})/2).
- Flag if the user mixes Convention A and B (this produces wrong normalizations).
</preset>

<output>
- The expansion up to the requested order, with each term labeled by (g,s) or power of the parameter.
- Coefficients expressed as intersection numbers, Euler characteristics, or closed-form when possible.
- Convergence notes: radius of convergence or asymptotic nature of the series.
</output>
