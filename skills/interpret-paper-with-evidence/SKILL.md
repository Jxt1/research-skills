---
name: interpret-paper-with-evidence
description: Interpret, explain, summarize, or answer questions about an academic paper while grounding every substantive claim, conclusion, comparison, and inference in quoted original text with precise locations. Use when the user asks for a paper walkthrough, close reading, section or method explanation, experiment or result analysis, contribution summary, limitation critique, novelty assessment, reviewer-style interpretation, or evidence-backed Q&A from a PDF, HTML paper, LaTeX source, or extracted full text.
---

# Interpret Paper With Evidence

Produce a traceable interpretation of a paper. Make every substantive statement auditable against the source the user supplied or an authoritative full-text version of the same paper.

## Non-Negotiable Evidence Rule

For every substantive claim in the answer, provide:

1. **Interpretation**: the claim, explanation, comparison, or conclusion being made.
2. **Original text**: a verbatim excerpt that supports it. Keep the excerpt as short as possible without removing necessary context.
3. **Location**: the most precise stable locator available.
4. **Connection**: a concise explanation of how the excerpt supports the interpretation when the relationship is not self-evident.

Treat statements about the paper's problem, motivation, assumptions, design, method, data, baselines, results, contributions, novelty, limitations, implications, and author intent as substantive. Treat derived calculations and cross-section syntheses as substantive too.

Do not present general domain knowledge, plausible explanations, or remembered facts as if they came from the paper. Either ground them in the paper, label them explicitly as external context and cite an external source if the user permits it, or omit them.

## Source Acquisition

1. Inspect user-provided and local sources before searching elsewhere.
2. Prefer, in order: publisher or proceedings full text, author manuscript, arXiv version, repository PDF, then extracted text.
3. Confirm that title, authors, and version match before using a different copy.
4. State which version was inspected. Warn when pagination, section numbering, tables, or wording may differ from the user's copy.
5. Do not claim full-paper coverage when only an abstract, preview, OCR fragment, or selected pages are accessible. State the access limitation at the start of the answer.

## Location Rules

Use the strongest locator the format supports:

- PDF: printed page number when visible, plus PDF page index if they differ; then section/subsection and paragraph, figure, table, equation, theorem, or footnote identifier.
- HTML: section/subsection heading plus paragraph ordinal; include an anchor when stable.
- LaTeX or plain text: repository-relative file path and line number, plus section heading when available.
- OCR or extracted text: PDF page, section heading, and a distinctive nearby phrase; mention that the text came from OCR when accuracy is uncertain.

Examples:

```text
p. 7 (PDF p. 9), Sec. 4.2, para. 2
p. 11, Table 3, row "Ours", column "F1"
src/method.tex:142, Sec. 3.1
Appendix B, Eq. (12)
```

Never give only a section name when a page, paragraph, line, table, figure, or equation locator is available. Never invent page or paragraph numbers. If no stable locator exists, provide the section heading and a unique short phrase that can be searched verbatim.

## Workflow

1. Identify the exact paper, version, source format, and the user's requested scope.
2. Read the relevant source directly. For a whole-paper interpretation, inspect at least the abstract, introduction, related work when needed for claimed novelty, method, experimental setup, results, discussion, limitations, conclusion, and relevant appendices.
3. Build an internal evidence ledger before drafting. Record each intended interpretation, its excerpt, locator, and whether support is direct or inferential.
4. Split compound conclusions into separately supported units. Do not use one excerpt to support adjacent claims it does not establish.
5. Draft using the evidence-block format below. Place evidence immediately after the claim it supports.
6. Audit every sentence before answering:
   - Can a reader identify the exact source for this statement?
   - Does the excerpt entail the whole statement at the same scope and strength?
   - Is the locator precise and real?
   - Is an inference clearly labeled?
7. Remove, narrow, or mark as unverified anything that fails the audit.

## Evidence Strength And Inference

Label the relationship when it matters:

- **Direct**: the paper explicitly states the point or reports the value.
- **Synthesized**: the point combines two or more separately cited passages or results.
- **Inference**: the point follows reasonably from cited evidence but is not stated by the authors.
- **Unverified**: accessible source text does not establish the point.

Use calibrated language. A result on one dataset does not establish universal superiority; an observed association does not establish causality; an author's novelty claim is not independent proof of novelty. Preserve qualifiers such as `may`, `under`, `on average`, confidence intervals, dataset scope, and experimental conditions.

For a numerical comparison, cite the exact table, figure, or passage and show the arithmetic used for any derived value. Distinguish absolute from relative changes.

## Required Answer Format

Start with the source version and access scope. Then organize the response around the user's question. Use one evidence block per substantive point:

```markdown
### <point title>

**Interpretation (<Direct | Synthesized | Inference | Unverified>):** <precise statement>

**Original text:** “<short verbatim excerpt>”

**Location:** <page + section/paragraph/table/figure/line locator>

**Connection:** <why this evidence supports the interpretation; required for synthesis or inference>
```

For synthesized points, include every necessary excerpt with its own location. For tabular results, transcribe only the relevant headers, cells, units, and conditions.

If the answer is long, end with an evidence index mapping each interpretation to its location. Do not replace the local evidence blocks with a detached bibliography or a list of page numbers.

## Translation And Quotation

- Preserve the original wording in **Original text**, including the source language.
- Put any translation in a separate **Translation** field and label it as your translation.
- Use ellipses only to omit irrelevant words; do not join fragments in a way that changes meaning.
- Include enough surrounding text to preserve negation, conditions, referents, and comparison baselines.
- When OCR is uncertain, mark uncertain characters and avoid conclusions that depend on them.

## Failure Modes

- If the paper is missing, request the PDF, full text, DOI, or stable link; do not fabricate an interpretation.
- If only metadata or an abstract is available, answer only what that material supports and label the limited scope.
- If evidence conflicts across sections, quote both passages, locate both, and explain the conflict without silently choosing one.
- If the user asks for an opinion, separate evidence-backed evaluation criteria from personal judgment. Ground the premises in source excerpts and label the final judgment as an evaluation.
- If no passage supports a requested conclusion, say `Not established by the inspected source` and list where you checked.

## Final Quality Check

Before returning the answer, verify that:

- every substantive point has adjacent original text and a precise location;
- every quote was checked against the inspected source rather than copied from search snippets or secondary summaries;
- no quote supports only part of a broader claim;
- author claims, measured results, and your inferences are visibly distinct;
- access and version limitations are explicit.
