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
- Part II (arXiv: 2412.13397): Strings from Feynman Diagrams, genus g=1 (torus)
- Part III (arXiv: 2510.17728): Matrix correlators as discrete volumes, all-genus
- The plugin must NOT be overfit to Part I (arXiv: 2212.05999) which is complete

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
