---
name: topological-recursion
description: Compute Eynard-Orantin W_{g,n} correlators for any spectral curve
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Read MAPPING_DICTIONARY §III for kernel K(p,q), Bergmann kernel B(p,q), and the full recursion formula.
3. Parse the user's request: extract the target (g,n) and, if no preset is active, the spectral curve data (x(p), y(p), branch points, involution).
4. Validate stability: check 2g - 2 + n > 0. If not, explain that the requested correlator is a base case or undefined.
5. Detect symbolic engine by probing in order:
   - `sage --version` (SageMath — preferred)
   - `wolframscript -code '1+1'` (Mathematica)
   - `python3 -c "import sympy"` (SymPy fallback)
6. Write a computation script to a temp file implementing:
   a. Define the spectral curve: x(p), y(p), the involution p -> p_bar, branch points.
   b. Implement B(p,q) (Bergmann kernel) and K(p,q) (recursion kernel).
   c. Implement the base cases W^{(0)}_3 and W^{(1)}_1.
   d. Build W^{(g)}_n by the general Eynard-Orantin recursion, summing over residues at branch points.
   e. Simplify and print the result.
7. Execute the script via Bash.
8. Interpret the output: present W^{(g)}_n in closed form or as a Laurent series. Note any poles and their orders.
9. If the computation fails or times out, fall back to computing one recursion level lower and explain the obstruction.
</process>

<preset>
When the triality preset is active:
- The spectral curve is Convention A from MAPPING_DICTIONARY §III:
  xy - y^2 = 1, uniformized as x = e^lambda + e^{-lambda}, y = e^lambda.
- Branch points are at x = +/-2 (lambda = 0 and lambda = i*pi).
- The involution is lambda -> -lambda (so y_bar = e^{-lambda}).
- Bergmann kernel: B(p,q) = de^lambda de^mu / (e^lambda - e^mu)^2.
- Recursion kernel: K(p,q) = de^lambda / [(e^lambda - e^mu)(e^mu - e^{-mu})^2 dmu].
- For genus-1 seed W^{(1)}_1, use the formula from MAPPING_DICTIONARY §VII.
- Use Giacchetto-Lewanski (2410.13273) notation conventions.
- Always distinguish Convention A (TR kernel) from Convention B (resolvent).
</preset>

<output>
- The correlator W^{(g)}_n(p_1,...,p_n) in closed or series form.
- Residue structure and pole orders at branch points.
- Verification: check the result satisfies the string equation or dilaton equation when applicable.
- If low (g,n), provide the explicit rational/trigonometric expression.
</output>
