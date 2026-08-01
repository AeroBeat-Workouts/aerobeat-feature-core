# AeroBeat Gameplay Architecture Resume

**Date:** 2026-08-01
**Status:** In Progress
**Last Updated:** 2026-08-01 15:27 EDT
**Blocked Reason:** None
**Agent:** pico

---

## Goal

Freeze the next AeroBeat gameplay feature architecture by mapping feature, content, input, assembly, and possible new gameplay-boundary repo responsibilities before any Boxing or Flow implementation begins.

---

## Overview

The latest AeroBeat handoff says the previous camera/input proving-scenes cleanup wave is complete and archived. There is no active implementation plan to resume; the next slice is a fresh gameplay architecture planning pass.

This plan uses `aerobeat-feature-core` as the owning repo because it is the canonical home for shared gameplay-mode and runtime-rule contracts. The planning pass should inspect the active gameplay repos, input contract repos, maps/content repos, assembly workbench shape, and any missing repo boundaries, then produce a concrete responsibility split for the first gameplay implementation wave.

This is primarily a discussion-first execution slice. No implementation work should start until the architecture split is explicit, the feature repo boundaries are agreed and frozen, the input-repo dependency shape is clear, and Derrick approves the next implementation plan. AeroBeat is a polyrepo project, so a clean new repo boundary is preferred over stuffing unrelated gameplay concerns into `aerobeat-feature-boxing`, `aerobeat-feature-flow`, or `aerobeat-feature-core`.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Latest recovered AeroBeat handoff | `/home/derrick/.openclaw/workspace/projects/openclaw-pico/handoffs/handoff-2026-07-31T13-51-00-04-00-aerobeat.md` |
| `REF-02` | Shared Feature-lane contract home | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-feature-core/README.md` |
| `REF-03` | Active Boxing feature repo truth | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-feature-boxing/README.md` |
| `REF-04` | Active Flow feature repo truth | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-feature-flow/README.md` |
| `REF-05` | Completed camera/input cleanup plan archive | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-input-camera-tracking/.plans/archive/2026-07-22-aerobeat-camera-tracking-and-beatsaver-feedback-wave.md` |
| `REF-06` | Shared content contract home | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/README.md` |
| `REF-07` | Shared input contract home | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-input-core/README.md` |
| `REF-08` | PC community assembly truth | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-assembly-community/README.md` |
| `REF-09` | Current architecture workflow rules | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/workflow.md` |
| `REF-10` | Current input architecture stance | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/input.md` |

---

## Working Boundary Proposal

This section is the live discussion surface. It is not frozen until Derrick explicitly agrees.

### Current Constraints

- Official v1 gameplay remains Boxing and Flow only.
- Official v1 gameplay input remains camera only.
- Mouse and touch are valid for UI/navigation, not official v1 gameplay parity.
- Keyboard, XR, Joy-Con, and native/mobile MediaPipe stay future/debug/exploration lanes unless a later plan promotes them.
- Feature repos should not talk directly to webcams, vendor runtimes, raw MediaPipe payloads, or camera-preview ownership.
- Content repos should not own gameplay scoring, runtime interpretation, UI, tools, or environment/coaching behavior.
- Assembly repos compose runnable products; they should wire concrete dependencies rather than become the source of reusable gameplay contracts.

### Preliminary Repo Responsibilities

- `aerobeat-feature-core`: shared gameplay-mode vocabulary, runtime-rule interfaces, feature lifecycle/state/scoring result contracts, and cross-feature rule seams reused by Boxing and Flow.
- `aerobeat-feature-boxing`: Boxing-specific chart interpretation, hit-window/rule evaluation, scoring semantics, combo/streak behavior, Boxing workbench scenes/tests, and any Boxing-specific visuals that are part of gameplay feedback.
- `aerobeat-feature-flow`: Flow-specific chart interpretation, grid/object/rule evaluation, scoring semantics, Flow workbench scenes/tests, and Flow-specific gameplay feedback.
- `aerobeat-content-core`: durable song-package, song, chart, set, schema, validation, and authored/imported content relationship rules, including Boxing/Flow chart object vocabulary where it is content truth rather than runtime behavior.
- `aerobeat-input-core`: stable provider/session/intent contracts, `BoxingInput`, `FlowInput`, `BodyCellInput`, UI interaction bridge contracts, and normalized lifecycle seams.
- `aerobeat-tool-camera-tracking`: vendor-agnostic camera lifecycle, source selection, preview ownership, backend resolution, and normalized tracking-frame publication.
- `aerobeat-input-camera-tracking`: camera gameplay interpretation layer that turns normalized `CameraTracking` frames into current Boxing/Flow input intents; it owns detector truth and should stay below feature rule evaluation.
- concrete input repos: device/provider packages that bridge hardware/runtime details into `aerobeat-input-core` contracts; future providers remain future until promoted.
- `aerobeat-tool-content-authoring` and `aerobeat-vendor-beatsaver`: acquisition, staging, conversion, and authoring workflows; they should emit/validate content through `aerobeat-content-core` rather than own runtime gameplay behavior.
- `aerobeat-assembly-community`: runnable PC community app composition, dependency pinning, camera sidecar packaging, product scenes, and integration tests.

### New Repo Boundary Under Discussion

There appears to be a clean potential boundary for a shared gameplay session/runner layer that should not be stuffed into feature repos:

- recommended name: `aerobeat-gameplay-runner`
- fallback names if Derrick dislikes that shape: `aerobeat-runtime-gameplay` or `aerobeat-gameplay-core`
- owner role: runtime composition state that is neither pure feature contract nor Boxing/Flow-specific logic
- concrete responsibilities: selected song package/chart, active feature runner selection, timeline clock binding to audio, input subscription wiring, event dispatch, per-session lifecycle, pause/resume/retry, common gameplay result envelope, and assembly-facing scene/controller glue
- possible consumers: assemblies, feature workbenches, and future product-specific clients
- possible dependencies: `aerobeat-feature-core`, `aerobeat-content-core`, `aerobeat-input-core`, and narrowly any timing/audio contract if needed
- explicit non-goals: no camera lifecycle, no detector logic, no BeatSaver conversion, no UI shell chrome, no environment loading, no concrete feature-specific judgement

The open question is whether this layer earns a new repo now, or whether the first implementation wave can keep the conductor inside `aerobeat-assembly-community` until the shared seam is proven.

### Proposed Dependency Direction

- feature repos -> `aerobeat-feature-core`
- feature repos -> `aerobeat-content-core` only when they consume chart/content contracts
- feature repos -> `aerobeat-input-core` for intent interfaces and fake/test streams, not concrete camera providers
- concrete input providers -> `aerobeat-input-core`
- `aerobeat-input-camera-tracking` -> `aerobeat-tool-camera-tracking` for normalized tracking frames and provider lifecycle
- vendor repos -> tool repos or concrete provider repos, not feature repos
- tool/content-authoring repos -> `aerobeat-content-core` for contract truth
- assembly/workbench repos -> every concrete package needed to run the slice through GodotEnv

### First Implementation Sequence After Freeze

1. Create `aerobeat-gameplay-runner` if Derrick approves the new boundary.
2. Normalize `aerobeat-feature-boxing` and `aerobeat-feature-flow` testbed manifests around `feature-core`, `content-core`, `input-core`, and GUT/headless validation.
3. Add minimal `feature-core` DTOs/interfaces for feature runner contracts, results, timing hooks, and lifecycle vocabulary.
4. Implement feature-local pure rule engines against fixture charts and fake input intent streams before live camera binding.
5. Wire `aerobeat-assembly-community` last through `addons.jsonc` once runner, features, content contracts, and camera input composition are proven.

### Unresolved Freeze Questions

- Should we approve `aerobeat-gameplay-runner` now, or allow a temporary assembly-only conductor while feature contracts mature?
- Should the runner own audio-clock binding and chart timeline dispatch, or delegate clocking to an audio/tool package while only subscribing to timing events?
- Should feature repos expose pure rule engines only, or also package Godot scenes/controllers for their in-game lane visuals?
- For v1, should Boxing and Flow both consume the same `BodyCellInput` lane where possible, or should Boxing primarily consume explicit `BoxingInput` events and reserve body-cell for debug/calibration?
- Should first fixtures come from converted BeatSaver `song-package.yaml` output, hand-authored minimal fixtures, or both?
- Should `aerobeat-assembly-community` be the first integration target immediately, or should the new gameplay runner/workbench prove composition first?

## Tasks

### Task 1: Recover Gameplay Architecture Context And Boundary Options

**Bead ID:** `afc-n5l`
**SubAgent:** `primary`
**Role:** `research`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** You are the `research` role on the `primary` lane for AeroBeat. Claim bead `afc-n5l` with `bd update afc-n5l --status in_progress --json`. Inspect the active AeroBeat gameplay, content/maps, input, and assembly repos needed to decide first implementation ownership. Summarize current repo responsibilities, package/testbed state, dependency contracts, and any missing repo boundaries. Pay special attention to what belongs in feature repos, what does not, and how feature repos should use input repos. Do not implement code. Update bead `afc-n5l` with findings; do not close it.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-08-01-aerobeat-gameplay-architecture-resume.md`

**Status:** In Progress

**Results:** Research pass completed and wrote proposal details into bead `afc-n5l`. Repo boundary findings are summarized in the Working Boundary Proposal. Implementation remains out of scope until the architecture is frozen.

---

### Task 2: Draft Architecture Freeze Proposal

**Bead ID:** `afc-n5l`
**SubAgent:** `primary`
**Role:** `research`
**References:** `REF-02`, `REF-03`, `REF-04`
**Prompt:** You are the `research` role on the `primary` lane for AeroBeat architecture documentation. Using the Task 1 findings, draft a discussion-ready architecture freeze proposal that defines the first implementation split across `aerobeat-feature-core`, `aerobeat-feature-boxing`, `aerobeat-feature-flow`, `aerobeat-content-core`, input repos, assembly/workbench repos, and any recommended new repos. Keep the output to architecture, repo boundaries, dependency direction, and execution sequencing only; do not implement runtime feature code. Update bead `afc-n5l` with the proposal; do not close it.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-08-01-aerobeat-gameplay-architecture-resume.md`

**Status:** In Review

**Results:** Drafted proposal now recommends `aerobeat-gameplay-runner` as the shared gameplay orchestration boundary rather than placing session/timeline/input/content/feature composition in `feature-core`, concrete feature repos, or the PC community assembly.

---

### Task 3: Derrick Architecture Review And Freeze Gate

**Bead ID:** `afc-n5l`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** You are the `auditor` role on the `primary` lane for AeroBeat. After Derrick reviews the proposal, verify that the frozen architecture is reflected in the plan, that implementation remains blocked until the freeze is explicit, and that any future implementation beads are clearly separated from this architecture bead. Confirm the plan does not reintroduce inactive Dance/Step language, does not blur feature/content/input/tool boundaries, and identifies any new repo creation boundary if needed. If Derrick freezes the architecture and the plan reflects it, close bead `afc-n5l` with the reason; otherwise leave it open with the exact unresolved decisions.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `Pending coder output`

**Status:** Pending Human Review

**Results:** Not started.

---

## Final Results

**Status:** Pending

**What We Built:** Architecture discussion plan and bead initialized. Implementation is explicitly deferred until Derrick freezes the architecture.

**Reference Check:** Research checked current feature, input, content, tool/vendor, assembly, environment, UI, docs, and handoff references. Derrick freeze decision pending.

**Commits:**
- Pending

**Lessons Learned:** Pending

---

*Drafted on 2026-08-01*
