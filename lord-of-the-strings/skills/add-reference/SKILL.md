---
name: add-reference
description: Fetch an arXiv e-print, extract raw LaTeX source, and add to the reference corpus
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Parse the arXiv ID from the user's input. Normalize format (e.g., "2410.13273" or "hep-th/0312171").

CRITICAL WARNING: Always verify arXiv IDs before downloading. LLM-suggested arXiv IDs are
frequently hallucinated — they may point to nonexistent papers or to entirely different papers
than intended. NEVER skip the verification step.

3. VERIFY the ID: Use WebFetch to retrieve `https://arxiv.org/abs/{ID}`.
   - Display the paper's title and authors to the user.
   - Ask the user to confirm this is the intended paper before proceeding.
   - If the page returns a 404 or the ID is invalid, report the error and stop.
4. After user confirmation, download the source:
   `curl -L -f https://arxiv.org/e-print/{ID} -o /tmp/{safename}.tar.gz`
   where `safename` is the arXiv ID with slashes replaced by hyphens.
5. Check the file type using `file -b /tmp/{safename}.tar.gz`:
   a. If gzip tarball: extract with `tar xzf` to `reference/source_tex/{safename}/`
   b. If single gzip tex file: `gunzip` and place in `reference/source_tex/{safename}/`
   c. If PDF only: report that no LaTeX source is available for this paper; save PDF to `reference/pdfs/{safename}.pdf` instead.
6. SECURITY validation before and after extraction:
   - Reject any extracted paths containing `../` (path traversal).
   - Reject any symlinks that point outside `reference/source_tex/{safename}/`.
   - If violations are found, delete the extracted directory and report the security issue.
7. Identify the main .tex file:
   - Look for the file containing `\begin{document}`.
   - If multiple matches, pick the largest one.
   - If no matches, pick the largest .tex file.
8. Copy the main file to `reference/source_tex/{safename}_main.tex` for easy access.
9. Report success:
   - Paper title and authors.
   - Number of .tex files extracted.
   - Line count of the main .tex file.
   - Path to the main file.
</process>

<preset>
When the triality preset is active:
- After extraction, scan the main .tex file for key terms: "Strebel", "ribbon graph", "fatgraph",
  "topological recursion", "Belyi", "tensionless", "symmetric orbifold", "discrete volume".
- Report which triality-relevant concepts appear in the paper.
- If the paper defines notation that overlaps with MAPPING_DICTIONARY conventions, flag the
  differences (e.g., different sign conventions, different normalization of the spectral curve).
- Suggest which section of the MAPPING_DICTIONARY the paper is most relevant to.
</preset>

<output>
- Confirmation of successful download and extraction (or error report).
- Paper metadata: title, authors, arXiv ID.
- Path to the main .tex file in the reference corpus.
- Line count and file count summary.
- If preset is active: triality relevance scan results.
</output>
