---
name: quiver
description: Generate LaTeX quiver diagram for a gauge theory using tikz-cd or quiver package
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Parse the user's specification: number of nodes, gauge group labels, arrows (with multiplicity and representation labels), and any loops.
3. Determine layout:
   - Linear quiver: nodes in a row.
   - Circular quiver: nodes on a circle.
   - Single node with loops: centered with loops at specified angles.
   - Custom: user-specified coordinates.
4. Generate compilable LaTeX code using tikz-cd:
   a. Include `\documentclass{standalone}` preamble with `\usepackage{tikz-cd}` and `\usetikzlibrary{decorations.markings}`.
   b. Draw each node as a circle with the gauge group label inside.
   c. Draw arrows between nodes with representation labels (fundamental, bifundamental, adjoint).
   d. For adjoint representations: draw loops at the node.
   e. For multiple arrows: offset them or use multiplicity labels.
5. Add decorations:
   - Flavor nodes as square boxes (distinguished from gauge nodes).
   - Dashed arrows for global symmetries.
   - Arrow labels for matter content (e.g., "X", "Y", "Z" for chiral multiplets).
6. Wrap in a LaTeX code block and present to the user.
</process>

<preset>
When the triality preset is active:
- Specialize to U(N) adjoint quivers relevant to N=4 SYM and its subsectors.
- Single-node quiver: one circular node labeled U(N) with an adjoint loop labeled Phi (the scalar in the Gaussian matrix model sector).
- For the full N=4 content: three adjoint loops labeled X, Y, Z (the three complex scalars).
- For the psu(1,1|2) subsector: annotate which fields survive the truncation.
- The Gaussian matrix model corresponds to the single-matrix reduction: one node U(N), one adjoint loop Phi, with potential W = (1/2) Tr Phi^2.
- Include the superpotential or matrix model potential as a caption below the diagram.
- Use notation consistent with MAPPING_DICTIONARY section V for the gauge-string duality context.
</preset>

<output>
- A compilable LaTeX code block (standalone document) with the quiver diagram.
- Nodes labeled with gauge groups, arrows labeled with matter representations.
- If preset is active: the matrix model potential displayed as a caption.
- Summary of the quiver data: number of gauge nodes, flavor nodes, total matter fields.
</output>
