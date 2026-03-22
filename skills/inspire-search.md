---
name: inspire-search
description: Search InspireHEP and arXiv for papers on any physics topic
---

<process>
1. Read `config/active-preset.txt`. If it contains a path, Read that preset file.
2. Parse the user's search query. If the preset is active, augment the query (see preset section).
3. URL-encode the query string.
4. Use WebFetch to query: `https://inspirehep.net/api/literature?q={encoded_query}&size=10&sort=mostrecent`
5. Parse the JSON response. For each hit, extract:
   a. Title (from `metadata.titles[0].title`)
   b. Authors (from `metadata.authors`, first 3 + "et al." if more)
   c. arXiv ID (from `metadata.arxiv_eprints[0].value`)
   d. Abstract snippet (first 200 characters of `metadata.abstracts[0].value`)
   e. Citation count (from `metadata.citation_count`)
   f. Publication year (from `metadata.earliest_date`)
6. If the API returns an error or empty results:
   - Retry with a simplified query (remove special characters, use fewer terms).
   - If still empty, suggest alternative search terms.
7. Format results as a numbered list with arXiv links: `https://arxiv.org/abs/{arXiv_ID}`
8. If the user asks for more details on a specific paper, fetch its full InspireHEP record.
</process>

<preset>
When the triality preset is active:
- Augment the user's query by appending:
  ` AND (tensionless OR k=1 OR topological recursion OR Strebel OR gauge-string duality)`
  This filters results to the tensionless string / AdS3/CFT2 corner of the literature.
- Highlight papers that cite or are cited by the core references:
  - Eberhardt-Gaberdiel-Gopakumar (1903.00421) — tensionless limit
  - Gaberdiel-Gopakumar (2011.04647) — worldsheet derivation
  - Giacchetto-Lewanski (2410.13273) — topological recursion for Belyi maps
  - Razamat (2105.01085) — Strebel parametrization
- Sort results by relevance to the triality: tensionless strings <-> free symmetric orbifold <-> topological field theory.
- Flag any results that appear to be new developments (published within the last 6 months).
</preset>

<output>
- A formatted numbered list of up to 10 papers, each showing:
  1. **Title** — Authors (Year)
     arXiv: [ID](link) | Citations: N
     Abstract snippet...
- If preset is active: relevance notes indicating connection to the triality program.
- Total number of results found (the API may have more than the 10 displayed).
</output>
