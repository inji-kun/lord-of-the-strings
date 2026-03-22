---
name: kazama-suzuki
description: Work with the SL(2,R)/U(1) Kazama-Suzuki coset at k=1 (A-model worldsheet for DSD-III)
---

> **SPECULATIVE SKILL** -- DSD-III is unpublished. The content here is grounded in the
> established literature (1812.01007, 1911.00378, 2009.11306) but the specific DSD-III
> derivation is not yet available. Use for exploration and framework-building, not as
> established results.

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Provide context on the Kazama-Suzuki coset SL(2,R)/U(1) at level k=1:
   a. The non-compact SL(2,R)/U(1) Kazama-Suzuki coset has central charge c = 3 + 6/k.
   b. At k=1, c = 9 — the critical value for a Calabi-Yau threefold target. This is NOT c=1; the c=1 connection comes from the auxiliary c=1 string description via analytic continuation (SU(2)/U(1) at k=-3), not from the KS coset itself.
   c. Do NOT confuse with c = 3k/(k+2), which is the compact SU(2)/U(1) minimal model formula.
   c. The A-twist of this coset coupled to topological gravity is the target of DSD-III.
3. Help with topological A-model observables:
   a. Spectral flow: relate NS and R sectors.
   b. Physical state conditions: cohomology of the topological twist.
   c. Chiral ring structure of the coset.
4. Connect coset data to Belyi map localization:
   a. The path integral of the A-twisted theory should localize to holomorphic maps.
   b. At k=1 (tensionless limit), these holomorphic maps are Belyi maps branched over {0, 1, ∞}.
   c. The localization points are integer Strebel points in M_{g,n}.
5. Cross-reference with the covering-map localization proof at genus 0 (1911.00378).
6. Relate to the psu(1,1|2)_1 worldsheet theory (1812.01007) and free field correlators (2009.11306).
</process>

<preset>
When the triality preset is active:
- Focus on the DSD-III target theory: the A-twisted Kazama-Suzuki SL(2,R)/U(1) coset at k=1 coupled to topological gravity.
- The key question: does the A-model path integral localize to Belyi maps (= Feynman diagrams)?
- At genus 0, the mechanism is established (1911.00378). Higher genus is the open problem.
- The B-model side (DSD-II) uses TR on W(z) = 1/z + t_2*z — the KS coset is the MIRROR of this.
- Corpus pointers: MAPPING_DICTIONARY §V, 1812.01007, 1911.00378, 2009.11306.
- IMPORTANT: This skill is SPECULATIVE — DSD-III is unpublished. The content is grounded in the established literature (1812.01007, 1911.00378, 2009.11306) but the specific DSD-III derivation is not yet available. Use for exploration and framework-building, not as established results.
</preset>

<output>
- Context on the KS coset structure at k=1 (central charge, representations, chiral ring).
- Spectral flow and physical state conditions for the topological twist.
- Connection between coset observables and Belyi map / covering-map data.
- Status assessment: what is established vs. what is conjectural for DSD-III.
- Pointers to relevant corpus sections for further reading.
</output>
