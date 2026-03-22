# MAPPING DICTIONARY: Gauge-String-Matrix Triality

This document correlates the core mapping rules across the Golden Corpus,
organized by technique for efficient lookup. Each section is tagged with its relevance to DSD-I, DSD-II, and/or DSD-III.

---

## I. FEYNMAN GRAPH TOPOLOGY → STREBEL GEOMETRY

**Used in:** DSD-I, DSD-II, DSD-III (foundational)

**Source:** `2212.05999` (Gopakumar-Mazenc, Part I), Sections 5–5.3

### The Master Bijection (Strebel's Theorem)

```latex
\text{pt} \in \mathcal{M}_{g,n} \times \mathbb{R}_{+}^{n}
  \underset{\text{Strebel's Thm}}{\Longleftrightarrow}
  \phi(z)\,dz^2
  \underset{\text{V/H Trajectories}}{\Longleftrightarrow}
  \text{Metrized ribbon graph w/ genus } g, \; n \text{ faces}
```
— `2212.05999`, unnumbered eq. near line 707

### The Strebel Differential

A meromorphic quadratic differential on $\Sigma_{g,n}$ with double poles at marked points:

```latex
q = \phi(z)\,dz^2, \qquad
\phi(z)\,dz^2 \overset{\text{near } k\text{-th pole}}{=}
  -\frac{L_k^2}{(2\pi)^2}\frac{dz^2}{z^2}
```
— `2212.05999`, Sec. 5.1 (eqs. near lines 719–734)

The $L_k$ are the **perimeter lengths** — the circumferences of asymptotic closed strings.

### The Strebel Metric

Away from zeroes and poles, the differential defines a locally flat metric:

```latex
ds^2 = |\phi(z)|\,dz\,d\bar{z}
```
— `2212.05999`, Eq. near line 727 (labeled `eq:StrebelMetric`)

### Vertical/Horizontal Trajectories

Curves $z_V(t)$ and $z_H(t)$ satisfying:

```latex
\phi(z_V(t))\left(\frac{dz_V}{dt}\right)^2 < 0 \quad\text{(vertical)}, \qquad
\phi(z_H(t))\left(\frac{dz_H}{dt}\right)^2 > 0 \quad\text{(horizontal)}
```
— `2212.05999`, Sec. 5.2 (lines 744–747)

### Edge Metrization

Each edge of the Strebel graph (connecting zeroes) acquires a length from the flat metric:

```latex
l_{ij} = \int_{\text{edge}} |dz|\sqrt{|\phi(z)|}
```
— `2212.05999`, Sec. 5.3 (described near line 841)

### Euler Characteristic

For a ribbon graph on a **closed** genus-$g$ surface with $n$ faces:

```latex
V - E + F = 2 - 2g \quad \text{(graph Euler formula, with } F = n \text{)}
```

This is distinct from the Euler characteristic of the **punctured** surface $\Sigma_{g,n}$:

```latex
\chi(\Sigma_{g,n}) = 2 - 2g - n
```

For a trivalent graph ($V = 2E/3$), these combine to give $E = 6g - 6 + 3n$ edges.
An $m$-th order zero of $\phi$ gives a vertex of valency $(m+2)$; generically cubic ($m=1$).
— `2212.05999`, line 850: "From $V-E+F = 2-2g$, a genus $g$ fatgraph with $n$ faces..."

### Perimeter (Loop) Constraint

Each face $I$ imposes:

```latex
\sum_{i \in \text{face } I} l_i = P_I \quad (= L_I)
```
The perimeter of each face equals the residue parameter $L_I$ of the Strebel differential.
— `1512.09309`, Sec. 3.1, line 718–720

---

## II. SCHWINGER ↔ STREBEL LENGTH MAPPING

**Used in:** DSD-I, DSD-II

**Source:** `2212.05999`, Sections 5.3–5.4

### The Schwinger Parametrization

```latex
\frac{1}{p^2} = \int_0^\infty d\tau\, e^{-\tau p^2}
```
— `2212.05999`, Eq. `eq:Schwinger` (line 924)

### V-Type Mapping (Schwinger → Strebel)

Homotopically equivalent edges are bunched: inverse Schwinger times add like parallel resistors. The Strebel length is **inversely proportional** to the effective Schwinger time:

```latex
l_{ij} = \frac{1}{(\tau_{\text{eff}})_{ij}} \qquad \text{(V-type duality)}
```
— `2212.05999`, Eq. `eq:inverseSchwinger` (line 931–932)

### F-Type Mapping (Direct identification)

In F-type duality, the Strebel length **is** the open string worldsheet time:

```latex
(\tau_0)_{ij} = l_{ij} \qquad \text{(F-type)}
```
— `2212.05999`, eq. near line 1008

### Integer Strebel Lengths (Matrix Models / Tensionless Limit)

For zero-dimensional gauge theories (matrix integrals), the Schwinger time is absent.
Instead, assign **integer** Strebel lengths:

```latex
l_{ij} = n_{ij}
```

where $n_{ij}$ is the number of homotopically equivalent Wick contractions ("string bits").
This picks out **discrete points** on $\mathcal{M}_{g,n}$.
— `2212.05999`, line 938; `1512.09309`, Sec. 3.2, lines 754–758

---

## III. TOPOLOGICAL RECURSION KERNELS

**Used in:** DSD-II (TR is the B-model derivation engine)

**Source:** `1512.09309` (Andersen-Chekhov-Norbury-Penner), Sec. 4; `1412.3286` (Eynard)

### The Spectral Curve (Gaussian means)

**Convention A** (used in `1512.09309` §4, TR recursion kernel):

```latex
\Sigma: \quad yx - y^2 = 1, \qquad
x = e^\lambda + e^{-\lambda}, \quad y = e^\lambda, \quad dx = (e^\lambda - e^{-\lambda})\,d\lambda
```
— `1512.09309`, Eq. near line 1543–1546

**Convention B** (used in `1512.09309` §3, Gaussian means resolvent):

```latex
x = e^\lambda + e^{-\lambda}, \quad y = \tfrac{1}{2}(e^\lambda - e^{-\lambda})
```
— `1512.09309`, line 700–702

These are related by the affine shift $y_B = y_A - x/2$. The algebraic curve is the same; the TR kernel $K(p,q)$ and Bergmann kernel $B(p,q)$ in §III above use **Convention A**. When comparing to resolvent-based formulas, use Convention B. Mixing conventions will produce incorrect normalizations.

### The Bergmann Kernel

```latex
B(p,q) = \frac{de^\lambda\, de^\mu}{(e^\lambda - e^\mu)^2}, \qquad
E(p,q) = \frac{de^\lambda}{e^\lambda - e^\mu}
```
— `1512.09309`, Eq. near line 1556 (labeled `Bpq`)

### The Recursion Kernel

```latex
K(p,q) = E(p,q) \cdot \frac{1}{(y(q) - \bar{y}(q))\,dx}
= \frac{de^\lambda}{e^\lambda - e^\mu} \cdot \frac{1}{(e^\mu - e^{-\mu})^2\,d\mu}
```
— `1512.09309`, Eq. near line 1561–1567 (labeled `Kpq`)

### The Eynard-Orantin Recursion

Base cases:

```latex
W^{(0)}_3(p_1,p_2,p_3) = \sum_{\text{res}\,dx=0} K(p_1,q)
  [B(p_2,q) + B(\bar{p}_2,q)][B(p_3,q) + B(\bar{p}_3,q)]
```

```latex
W^{(1)}_1(p_1) = \sum_{\text{res}\,dx=0} K(p_1,q)\,B(q,\bar{q})
```

General recursion ($2g - 2 + s > 0$):

```latex
W^{(g)}_s(p_1,\ldots,p_s) = \sum_{\text{res}\,dx=0} K(p_1,q) \Bigl[
  \sum_{k=2}^s [B(p_k,q) + B(\bar{p}_k,q)]\,W^{(g)}_{s-1}(q,\ldots,\hat{p}_k,\ldots)
  + W^{(g-1)}_{s+1}(q,q,p_2,\ldots,p_s)
  + \sum_{\substack{g_1+g_2=g \\ I \sqcup J = \{p_2,\ldots,p_s\}}}^{\prime}
    W^{(g_1)}_{|I|+1}(q,I)\,W^{(g_2)}_{|J|+1}(q,J) \Bigr]
```
— `1512.09309`, Eqs. `W03`, `W11`, `recursion` (lines 1573–1589)

The $\sum'$ excludes unstable terms ($2g-2+s \leq 0$).

---

## IV. KONTSEVICH-PENNER MODEL & INTERSECTION THEORY

**Used in:** DSD-II (Kontsevich-Penner is the matrix model side)

**Source:** `1512.09309`, Sec. 3; `math/0111082` (Fiorenza-Murri)

### The Kontsevich Matrix Integral

```latex
e^{\sum_{g,s} N^{2-2g}\alpha^{2-2g-s}\mathcal{F}^{(g,s)}_K(\{\xi_k\})}
= \frac{\int DX\, e^{-\alpha N\,\text{tr}[\frac{1}{2}X^2\Lambda + X^3/6]}}
       {\int DX\, e^{-\alpha N\,\text{tr}[\frac{1}{2}X^2\Lambda]}}
```
— `1512.09309`, Eq. `Kont` (line 741–744)

### Kontsevich Times

```latex
\xi_k = \frac{1}{N}\sum_{i=1}^N \frac{(2k)!}{\lambda_i^{2k+1}}
```
— `1512.09309`, Eq. `times-K` (line 748)

### Intersection Numbers via Laplace Transform

```latex
\iint_0^\infty dP_1\cdots dP_s\, e^{-\sum_I P_I\lambda_I}
\int_{\overline{\mathcal{M}}_{g,s}} \prod_{I=1}^s P_I^{2d_I}\psi_I^{d_I}
= \langle\tau_{d_1}\cdots\tau_{d_s}\rangle_g \prod_I \frac{(2d_I)!}{\lambda_I^{2d_I+1}}
```
— `1512.09309`, Eq. `Kontsevich` (line 728–733)

### Discrete Moduli (Integer Strebel Lengths)

All edge lengths $l_i \in \mathbb{Z}_+$. Replace integration over $\mathcal{M}_{g,s}$ with **summation over integer points**. The perimeter constraint becomes:

```latex
\sum_{i \in \text{face } I} l_i = P_I \in \mathbb{Z}_+
```

**Parity note:** Each edge contributes to exactly two face perimeters, so the **total** $\sum_{I=1}^s P_I$ is always even. Individual perimeters $P_I$ can be odd.
— `1512.09309`, Sec. 3.2 (lines 756–762)

---

## V. THE STRING DUALS: B-MODEL, A-MODEL, AND LOCALIZATION

**Used in:** DSD-I, DSD-III

**Sources:** `1812.01007` (Eberhardt-Gaberdiel-Gopakumar) for the worldsheet theory and spectrum; `1911.00378` (Eberhardt-Gaberdiel-Gopakumar) for the localization/covering-map proof; `2009.11306` (Dei-Gaberdiel-Gopakumar-Knighton) for free field correlators

### The B-Model Dual (Target of DSD-II)

```latex
W(z) = \frac{1}{z} + t_2 z
```

Spectral curve: x(z) = W(z) = 1/z + t_2*z, y(z) = -W'(z) = 1/z^2 - t_2. The TR algorithm on this curve generates the B-model correlators. The free fermion formalism (2412.13397) bridges the matrix model to this LG description.

### Belyi Maps (Central to DSD-III)

A Belyi map is a holomorphic map P: Σ_{g,n} → CP^1 branched over only 3 points.
For the triality program, Feynman diagrams ARE Belyi maps:
- Vertices → preimages of 1
- Edge midpoints → preimages of 0
- Face centers → preimages of ∞

This provides the combinatorial bridge to the A-model (Kazama-Suzuki) worldsheet. See 2212.05999 §8 and the description of DSD-III in §1.2.

### The Worldsheet Theory

Superstring on $\text{AdS}_3 \times \text{S}^3 \times \mathbb{T}^4$ at $k=1$ (one unit of NS-NS flux) is described in the hybrid formalism by the $\mathfrak{psu}(1,1|2)_1$ WZW model.
— `1812.01007`, Sec. 1 (abstract + line 42)

### Key Result: No Long String Continuum

At $k=1$, a null vector at $h=2$ removes continuous representations. The spectrum **exactly matches** $\text{Sym}^N(\mathbb{T}^4)$ — the free symmetric product orbifold.
— `1812.01007`, line 84–89

### Physical State Condition

Physical states are the cohomology of the twisted $\mathcal{N}=4$ algebra. Only **short representations** of the worldsheet CFT contribute to the string spectrum — a signature that the theory is topological.
— `1812.01007`, lines 106–108

### String Coupling

```latex
g_s^2 \sim \frac{Q_5 \cdot \text{vol}(\mathbb{T}^4)}{Q_1} = \frac{\text{vol}(\mathbb{T}^4)}{N}
```
— `1812.01007`, eq. near line 93

### Localization on Moduli Space

The worldsheet correlators are **delta-function-localised** in string moduli space to configurations that admit a holomorphic covering map from the worldsheet to the boundary $\mathbb{CP}^1$.
— `1911.00378` (Eberhardt-Gaberdiel-Gopakumar, "Deriving the AdS3/CFT2 correspondence")

**Connection to integer Strebel (conjectural for general genus):** For correlators with large twist (BMN-like limit), the covering-map localization points coincide with integer Strebel differentials, as shown explicitly for genus 0 in `2212.05999` (line 938) and Gaberdiel-Gopakumar-Knighton-Maity `2011.10038` ("From symmetric product CFTs to AdS3"). The identification at higher genus is a key target of Parts II and III — it should be treated as a conjecture to be verified, not an established theorem.

### The $\mathfrak{psu}(1,1|2)_1$ Algebra

```latex
[J^+_m, J^-_n] = km\delta_{m+n,0} - 2J^3_{m+n}
\{S^{\alpha\beta\gamma}_m, S^{\mu\nu\rho}_n\} = km\epsilon^{\alpha\mu}\epsilon^{\beta\nu}\epsilon^{\gamma\rho}\delta_{m+n,0}
  - \epsilon^{\beta\nu}\epsilon^{\gamma\rho}c_a\sigma_a^{\alpha\mu}J^a_{m+n}
  + \epsilon^{\alpha\mu}\epsilon^{\gamma\rho}\sigma_a^{\beta\nu}K^a_{m+n}
```
— `1812.01007`, Eqs. near lines 150–159

---

## VI. CROSS-PILLAR TRANSLATION TABLE

| Gauge Theory (Pillar I) | String Theory (Pillar II) | Matrix Model (Pillar III) |
|---|---|---|
| Feynman diagram | Strebel skeleton on $\Sigma_{g,n}$ | Fat graph in cell decomposition of $\mathcal{M}_{g,s}$ |
| Schwinger parameter $\tau$ | Strebel edge length $l$ (V-type: $l = 1/\tau_{\text{eff}}$; F-type: $l = \tau$) | Edge length $l_i \in \mathbb{R}_+$ (or $\mathbb{Z}_+$) |
| $1/N$ expansion at genus $g$ | Worldsheet of genus $g$ | $N^{2-2g}$ term in matrix model |
| $n$-point correlator $\langle\text{Tr}M^{k_1}\cdots\rangle$ | $n$ punctures on $\Sigma_{g,n}$ with perimeters $L_i$ | $s$-point function in Kontsevich model |
| Wick contraction count $n_{ij}$ | Integer Strebel length $l_{ij}$ | Integer edge in discrete moduli |
| Graph: $V - E + F = 2 - 2g$ (with $F = n$) | Punctured surface: $\chi(\Sigma_{g,n}) = 2 - 2g - n$ | Same combinatorics; $F = n$ faces = $n$ punctures |
| Face of ribbon graph | Pole of Strebel diff. / puncture | Face of fat graph |
| Vertex of ribbon graph | Zero of Strebel diff. | Vertex of fat graph |
| Loop constraint $\sum l_i = P_I$ | Perimeter of asymptotic closed string | Boundary of face in cell decomposition |
| Free field ($k=1$) limit | Tensionless string / $\mathfrak{psu}(1,1|2)_1$ | Covering-map localization (`1911.00378`); integer Strebel identification conjectural at higher genus |
| Genus $g=1$ non-planar diagrams | Torus worldsheet (Part II target) | $W^{(1)}_1 = \sum K(p_1,q)B(q,\bar{q})$ |

---

## VII. SUPPORTING COMPUTATIONS FOR DSD-II AND DSD-III

The following are **supporting subproblems**, not the definitions of DSD-II/III themselves:

- **DSD-II subproblem:** Derive LG correlators via TR on W(z) = 1/z + t_2*z, match to matrix model
- **DSD-III subproblem:** Prove Belyi localization reproduces integer Strebel points at genus 1 and beyond

The **immediate** computational targets:

1. **Torus TR seed:** $W^{(1)}_1(p_1) = \sum_{\text{res}\,dx=0} K(p_1,q)\,B(q,\bar{q})$
   — Source: `1512.09309`, Eq. `W11`

2. **Non-planar Feynman diagrams:** Identify all $g=1$ ribbon graphs for $n$-point functions, verify $V - E + F = 2 - 2(1) = 0$ (i.e., $V - E + n = 0$, so $V - E = -n$).
   — Method: Enumerate via `2412.13397`

3. **Integer Strebel check:** For each $g=1$ graph, verify that the integer Strebel lengths satisfy the perimeter constraints and that the mapping $l_i = n_i$ gives a valid point on $\mathcal{M}_{1,n}$.
   — Cross-ref: `2510.17728` (discrete volumes)

4. **Localization verification:** Confirm that the $k=1$ worldsheet covering-map localization (`1911.00378`) produces the same discrete $g=1$ points as the integer Strebel construction. This is a key conjecture to verify, not an established result at $g=1$.
   — Cross-ref: `1812.01007`
