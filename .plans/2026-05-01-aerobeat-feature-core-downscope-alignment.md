# AeroBeat Feature Core Downscope Alignment

**Date:** 2026-05-01  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Align `aerobeat-feature-core` with the downscoped AeroBeat v1 feature truth so the repo no longer presents removed gameplay modes as active peer surfaces.

---

## Overview

With `aerobeat-docs`, `aerobeat-tool-content-authoring`, and `aerobeat-content-core` now aligned, `aerobeat-feature-core` is the next shared contract surface likely to keep reintroducing removed gameplay lanes if left stale. This repo should reflect the approved product truth clearly: official v1 gameplay features are `boxing` and `flow`; `dance` and `step` are removed from active scope; future feature expansion may still happen later, but the core repo should not teach removed modes as equal-status current consumers.

This slice should focus on truthful shared feature-core scope, contract language, tests, and examples. We want the repo to support the active feature architecture without silently reasserting the broader pre-downscope worldview.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Active plan for this repo-local cleanup slice | `.plans/2026-05-01-aerobeat-feature-core-downscope-alignment.md` |
| `REF-02` | Updated AeroBeat docs source of truth | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs` |
| `REF-03` | Parent coordination plan and matrix | `/home/derrick/.openclaw/workspace/projects/openclaw-chip/.plans/2026-05-01-aerobeat-polyrepo-downscope-audit.md` |
| `REF-04` | Recently aligned content-core contract surface | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core` |

---

## Tasks

### Task 1: Audit `aerobeat-feature-core` for stale downscope assumptions

**Bead ID:** `oc-x88`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Audit this repo against the updated docs and aligned content/tool contract surfaces. Identify stale feature-core assumptions such as active `dance`/`step` peer truth, broad old examples/docs/tests, or any shared feature abstractions that still encode removed gameplay modes as current official scope. Do not edit yet; produce an execution-ready list.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/`
- `src/`
- `tests/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-01-aerobeat-feature-core-downscope-alignment.md`
- `docs/**`
- `src/**`
- `tests/**`

**Status:** ✅ Complete

**Results:** Completed the stale-scope audit. Main finding: this repo has almost no tracked contract/code/test surface yet, and the only meaningful downscope drift is concentrated in `README.md`, which still presents `boxing`, `dance`, `step`, and `flow` as equal active consumers of feature-core. No deeper tracked `src/`, `docs/`, or `tests/` surfaces currently reassert stale gameplay truth. The coder pass for this slice should therefore be a narrow README truth-alignment pass, not a synthetic code/test scaffolding pass.

---

### Task 2: Apply the repo cleanup and scope alignment

**Bead ID:** `oc-5eo`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** After the audit/action list is approved, update this repo so its shared contracts, docs, examples, and tests match the downscoped AeroBeat v1 feature truth. Commit and push by default.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/`
- `src/`
- `tests/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-01-aerobeat-feature-core-downscope-alignment.md`
- `docs/**`
- `src/**`
- `tests/**`

**Status:** ✅ Complete

**Results:** Applied the narrow README truth-alignment pass. `README.md` now states that official v1 gameplay features are `boxing` and `flow`, removes active-peer framing for `dance` and `step`, and preserves future extensibility wording without implying current support parity. The slice stayed narrow as intended: no code/tests were added or modified. Validation consisted of reading back the README plus `git diff -- README.md` and `git status --short` sanity checks before commit. Changes were committed/pushed as `429987b` (`Align feature-core README with v1 feature scope`). The only extra repo-state note was an unrelated untracked plan path, which was intentionally left out of the commit.

---

### Task 3: QA and audit the alignment

**Bead ID:** `oc-sqg` (QA), `oc-9vi` (Auditor)  
**SubAgent:** `primary`  
**Role:** `qa` then `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Independently verify that this repo no longer presents removed gameplay modes as active feature-core truth and stays aligned with the docs/content-core/tooling contract surfaces.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/`
- `src/`
- `tests/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-01-aerobeat-feature-core-downscope-alignment.md`
- `docs/**`
- `src/**`
- `tests/**`

**Status:** ⏳ In Progress

**Results:** QA pass completed with no fixes required and recommended auditor handoff. QA confirmed that `README.md` now states official v1 gameplay features are `boxing` and `flow`, removes active-peer framing for `dance` and `step`, preserves future extensibility without implying current support parity, and that the repo state matches the intended narrow docs-only slice: commit `429987b` touches only `README.md`, with no tracked `src/`, `docs/`, or `tests/` surfaces reasserting stale feature truth.

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Draft repo-local plan for the next shared feature-scope cleanup slice.

**Reference Check:** Pending repo audit and execution.

**Commits:**
- None yet.

**Lessons Learned:** Once docs/content/tooling truth is aligned, shared feature-core surfaces need the same treatment or they will keep reintroducing removed gameplay lanes through examples and abstractions.

---

*Completed on 2026-05-01*