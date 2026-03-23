---
name: fatgraph
description: Generate TikZ code for a ribbon graph (fatgraph) with specified genus, valency, and edge structure
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Read MAPPING_DICTIONARY section I for ribbon graph conventions, vertex/edge/face labeling, and orientation data.
3. Parse the user's specification: number of edges E, genus g, number of faces n, and any valency constraints (e.g., trivalent).
4. Validate topology using the Euler relation: V - E + n = 2 - 2g.
   - For trivalent graphs: E = 6g - 6 + 3n, V = 4g - 4 + 2n.
   - If the input is inconsistent, report which constraint fails and suggest valid parameter combinations.
5. Determine graph structure:
   - If the user names a specific graph (e.g., "theta graph", "Mercedes", "sunset"), construct its combinatorial data.
   - If only (g, E, n) are given, choose a representative ribbon graph with those invariants.
   - Record the cyclic orderings at each vertex (the "fat" structure).
6. Generate compilable TikZ/LaTeX code:
   a. Place vertices using a layout algorithm: circular for planar graphs, torus-adapted for g=1.
   b. Draw edges as ribbons (parallel curves) using TikZ `\draw` with `double` or custom ribbon style.
   c. Label vertices v_1, ..., v_V; edges e_1, ..., e_E; faces F_1, ..., F_n.
   d. Color faces distinctly using a pastel palette for visual clarity.
   e. Include a `\documentclass{standalone}` preamble so the output is directly compilable.
7. Wrap the code in a LaTeX code block and present to the user.
</process>

<preset>
When the triality preset is active:
- Specialize to Strebel skeletons: label each edge e_i with its Strebel length l_i.
- Label each face F_I with its perimeter P_I.
- Enforce the perimeter constraint: for each face, the sum of Strebel lengths of its boundary edges equals P_I.
  (Edges bordering the same face on both sides contribute 2*l_i to that face's perimeter.)
- Use notation from MAPPING_DICTIONARY section I: half-edges carry orientation, vertices carry cyclic ordering.
- For integer Strebel graphs: annotate edges with integer lengths n_i (Wick contraction counts).
- Include a caption showing the Euler data: g, V, E, n and the perimeter vector (P_1, ..., P_n).
- For genus-1 graphs: use a rectangular fundamental domain layout with edge identifications shown.
</preset>

<output>
- A compilable LaTeX/TikZ code block (standalone document) that can be pasted directly into a .tex file and compiled.
- Vertex, edge, and face labels clearly displayed in the diagram.
- A summary of the graph's combinatorial data: genus, vertex count, edge count, face count, valency sequence.
- If preset is active: Strebel lengths and perimeter constraints annotated on the diagram.
</output>
