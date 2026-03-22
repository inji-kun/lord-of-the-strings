> **Historical note:** This is the original spec from before the DSD-II/III framing correction. See SOUL.md for the current understanding of Parts II and III.

Spec: The Lord of the Strings (Plugin for Claude Code)

1. Vision Statement

The Lord of the Strings is a specialized Research Assistant (RA) plugin designed to complete the "Gauge-String-Matrix Triality" trilogy. It bridges the gap between perturbative Gauge Theory (Feynman diagrams) and the geometry of the String Worldsheet (Moduli Space of Riemann Surfaces) specifically for the tensionless limit (k=1).

2. Core Functional Requirements

A. The "Strebel-Schwinger" Mapper (Tool)

Goal: Automate the mapping between the field theory Schwinger parameters (σi​) and the string theory Strebel edge lengths (li​).

    Input: A Feynman diagram topology (adjacency list/matrix).

    Logic: * Generate the dual Ribbon Graph (Fatgraph).

        Compute the Euler Characteristic (χ=V−E+F=2−2g−n).

        Solve the Strebel condition: ∑i∈loop​li​=Perimeter.

    Output: The integrand contribution for the worldsheet moduli space Mg,n​.

B. Topological Recursion MCP (External Engine)

Goal: Interface Claude with a symbolic engine (Mathematica/Sage) to perform Eynard-Orantin recursion.

    Focus: Specifically for Parts II and III (Higher Genus g>0).

    Capabilities:

        Define the Spectral Curve (x,y) derived from the matrix model.

        Recursively compute Wg,n​ (correlators).

        Verify if the gauge theory 1/N expansion matches the topological recursion results.

C. The "Triality" Knowledge Base (RAG)

Goal: Prevent hallucinations by grounding Claude in the "Tensionless String" literature.

    Primary Sources: * Gopakumar & Mazenc (Parts I).

        Giacchetto et al. (Topological Recursion papers).

        Gaberdiel & Gopakumar (k=1 AdS3​/CFT2​ duality).

        Eberhardt (Free field realizations).

    Constraint: Prioritize the PSU(1,1∣2) symmetry group and the "Strebel skeleton" approach over standard "Heavy String" (Large tension) methods.

D. Lean 4 Formalization Layer

Goal: Interface with the project's Lean 4 environment (lakefile.lean) to provide machine-checked verification of key identities in the triality derivation.

    Capabilities:

        formalize_lemma: Takes a LaTeX equation and suggests a Lean `theorem` name and statement using mathlib4 conventions.

        proof_search: Leverages Lean's `aesop` or `omega` tactics to attempt closing small combinatorial gaps in the triality derivation.

        moduli_space_definitions: A specialized RAG bridge that knows the current state of "Moduli Space" formalization in Lean (e.g., work by the geometry community) so the RA doesn't reinvent the wheel.

    Example Interaction:
        User: "Claude, I've derived the Strebel lengths for the genus-1 case in my .tex file. Can you sketch a Lean proof that these lengths are strictly positive?"
        Claude: "Checking the Strebel conditions... Based on Mathlib.Analysis.Calculus, I've drafted a lemma in `formal/StrebelPositivity.lean`. Running `lake build`... The proof is valid for g=1."

E. LaTeX & TikZ "Fatgraph" Generator (Skill)

Goal: Rapidly draft paper-ready visuals for complex ribbon graphs.

    Commands:

        /fatgraph [edges] -> Generates TikZ code for a ribbon graph with specified genus.

        /quiver [nodes] -> Generates LaTeX for the dual gauge theory quiver.

3. Technical Architecture

MCP (Model Context Protocol) Servers

    symbolic-math-mcp: A bridge to wolframscript for solving the quadratic differentials associated with Strebel points.

    inspire-hep-mcp: Real-time querying of the InspireHEP API to track citations and preprints from the "tensionless" community.

    lean4-mcp: A bridge to the project's Lean 4 environment (`lake build`, `lake env`). Provides `formalize_lemma`, `proof_search`, and `moduli_space_definitions` capabilities. Requires a working Lean 4 / mathlib4 installation.

Skills (/skills/)

    check_anomaly_cancellation: Logic to verify that the derived stringy integrand doesn't have hidden divergences at the boundaries of moduli space.

    matrix_model_expander: Automates the 't Hooft 1/N expansion for Kontsevich-type matrix models.

4. Persona & Tone Guidelines

    Role: You are a "Third Collaborator" who has the combinatorial stamina that humans lack.

    Tone: Rigorous, mathematically precise, but slightly playful regarding the "Trilogy."

    Verification First: Never assume a duality holds. Always ask: "Shall we check the modular invariance for this genus-g contribution before proceeding?"

5. Success Metrics for Parts II & III

    Part II (Higher Genus): Can the plugin successfully identify all g=1 ribbon graphs for a 4-point function?

    Part III (The Partition Function): Can the plugin perform the sum over all g,n to show the full "Triality" matches the Matrix Model?