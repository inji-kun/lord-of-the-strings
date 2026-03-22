# Triality Preset

## Conventions
- Use notation from Giacchetto-Lewanski (arXiv: 2410.13273, Les Houches notes)
- Schwinger parameters: σ_i or τ_i
- Strebel lengths: l_i or l_{ij}
- Integer Strebel: l_{ij} = n_{ij} (number of Wick contractions)
- Always distinguish V-type (l = 1/τ_eff) from F-type (l = τ) mappings

## Spectral Curve
Convention A (for TR recursion kernel, from 1512.09309 §4):
- Algebraic equation: xy - y^2 = 1
- Uniformization: x = e^λ + e^{-λ}, y = e^λ
- Branch points: x = ±2 (λ = 0, iπ)

Convention B (for resolvent, from 1512.09309 §3):
- x = e^λ + e^{-λ}, y = (e^λ - e^{-λ})/2
- Related to Convention A by: y_B = y_A - x/2

IMPORTANT: The TR kernel K(p,q) and Bergmann kernel B(p,q) in the MAPPING_DICTIONARY use Convention A. When comparing to resolvent-based formulas, use Convention B.

## Active Research Focus
- DSD-II (unpublished): Derive the B-model dual — topological Landau-Ginzburg with W(z) = 1/z + t_2*z via topological recursion. Key precursor: `2412.13397` (Strings from Feynman Diagrams)
- DSD-III (unpublished): Derive the A-model dual — Kazama-Suzuki SL(2,R)/U(1) at k=1 via Belyi maps and covering-map localization. Key precursor: `2510.17728` (Matrix Correlators as Discrete Volumes)
- The plugin must NOT be overfit to Part I (arXiv: 2212.05999) which is complete

### B-Model Target (DSD-II)
- Superpotential: W(z) = 1/z + t_2*z (deformation of the c=1 string background)
- Spectral curve: x(z) = 1/z + t_2*z, y(z) = 1/z^2 - t_2
- Goal: Show TR on this curve reproduces matrix model correlators as intersection numbers on M_{g,n}
- Free fermion bridge from 2412.13397 is a key intermediate step
- The B-model is a topological LG theory coupled to 2D topological gravity

### A-Model Target (DSD-III)
- Worldsheet: A-twisted Kazama-Suzuki SL(2,R)/U(1) at k=1
- Belyi maps: Feynman diagrams ARE holomorphic maps branched over 3 points ({0, 1, ∞})
  - Vertices → preimages of 1
  - Edge midpoints → preimages of 0
  - Face centers → preimages of ∞
- Localization: string path integral localizes to discrete points = integer Strebel points
- This is the LESS developed side — DSD-III is further from completion
- Status: conjectural at higher genus, proven mechanisms exist at genus 0 (1911.00378)

## Preferred Sources by Topic
- Strebel geometry: 2212.05999 §5, MAPPING_DICTIONARY §I
- Schwinger-Strebel mapping: 2212.05999 §5.3-5.4, MAPPING_DICTIONARY §II
- TR kernels: 1512.09309 §4, MAPPING_DICTIONARY §III
- Kontsevich-Penner: 1512.09309 §3, math/0111082, MAPPING_DICTIONARY §IV
- k=1 localization: 1911.00378, 1812.01007, 2009.11306, MAPPING_DICTIONARY §V
- Integer Strebel: 0803.2681 (Razamat)
- Discrete volumes: 2510.17728, 0801.4590 (Norbury)
- Moduli spaces: 2410.13273 (Giacchetto-Lewanski Les Houches)

## Euler Characteristic
For ribbon graphs: V - E + F = 2 - 2g (where F = n faces)
For punctured surfaces: χ(Σ_{g,n}) = 2 - 2g - n
These are DIFFERENT formulas — do not conflate them.

## Custom Instructions
(Edward can add his own notes here)
