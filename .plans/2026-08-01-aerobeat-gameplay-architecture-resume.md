# AeroBeat Gameplay Architecture Resume

**Date:** 2026-08-01
**Status:** In Progress
**Last Updated:** 2026-08-01 16:05 EDT
**Blocked Reason:** None
**Agent:** pico

---

## Goal

Freeze the next AeroBeat gameplay feature architecture by mapping feature, content, input, assembly, and possible new gameplay-boundary repo responsibilities before any Boxing or Flow implementation begins.

---

## Overview

The latest AeroBeat handoff says the previous camera/input proving-scenes cleanup wave is complete and archived. There is no active implementation plan to resume; the next slice is a fresh gameplay architecture planning pass.

This plan uses the current `aerobeat-feature-core` repo as the owning repo until the approved in-place rename moves it to `aerobeat-mode-core`. It is the canonical home for shared gameplay-mode and runtime-rule contracts. The planning pass should inspect the active gameplay repos, input contract repos, maps/content repos, assembly workbench shape, and any missing repo boundaries, then produce a concrete responsibility split for the first gameplay implementation wave.

This is primarily a discussion-first execution slice. No implementation work should start until the architecture split is explicit, the mode repo boundaries are agreed and frozen, the input-repo dependency shape is clear, and Derrick approves the next implementation plan. AeroBeat is a polyrepo project, so a clean new repo boundary is preferred over stuffing unrelated gameplay concerns into the Boxing, Flow, or shared mode contract repos.

Derrick approved the `aerobeat-gameplay-runner` boundary: the runner is where AeroBeat runs a song with either Boxing or Flow gameplay, while the rules for those modes stay in the gameplay-mode repos. During this same architecture section, Derrick also approved renaming `feature` terminology to `mode` terminology across the AeroBeat polyrepo before implementation begins.

Approved rename decisions:

- Rename existing GitHub repos in place rather than creating replacement repos.
- Rename `aerobeat-feature-core`, `aerobeat-feature-boxing`, and `aerobeat-feature-flow` to `aerobeat-mode-core`, `aerobeat-mode-boxing`, and `aerobeat-mode-flow`.
- Rename `aerobeat-template-feature` to `aerobeat-template-mode` in the same wave.
- Migrate serialized content/package/chart schema fields from `feature` to `mode` now; do not keep the legacy field as the canonical contract.
- Treat compatibility/fixtures/importer/test updates as part of the schema migration rather than a deferred cleanup.

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

This section is the live discussion surface. The runner boundary, repo rename direction, template rename, schema migration direction, and runner repo structure are now approved; final implementation architecture remains open until the concrete rename/schema migration plan and runner bootstrap plan are audited.

### Current Constraints

- Official v1 gameplay modes remain Boxing and Flow only.
- Official v1 gameplay input remains camera only.
- Mouse and touch are valid for UI/navigation, not official v1 gameplay parity.
- Keyboard, XR, Joy-Con, and native/mobile MediaPipe stay future/debug/exploration lanes unless a later plan promotes them.
- Mode repos should not talk directly to webcams, vendor runtimes, raw MediaPipe payloads, or camera-preview ownership.
- Content repos should not own gameplay scoring, runtime interpretation, UI, tools, or environment/coaching behavior.
- Assembly repos compose runnable products; they should wire concrete dependencies rather than become the source of reusable gameplay contracts.

### Preliminary Repo Responsibilities

- `aerobeat-feature-core` -> target `aerobeat-mode-core`: shared gameplay-mode vocabulary, runtime-rule interfaces, mode lifecycle/state/scoring result contracts, and cross-mode rule seams reused by Boxing and Flow.
- `aerobeat-feature-boxing` -> target `aerobeat-mode-boxing`: Boxing-specific chart interpretation, hit-window/rule evaluation, scoring semantics, combo/streak behavior, Boxing workbench scenes/tests, and any Boxing-specific visuals that are part of gameplay feedback.
- `aerobeat-feature-flow` -> target `aerobeat-mode-flow`: Flow-specific chart interpretation, grid/object/rule evaluation, scoring semantics, Flow workbench scenes/tests, and Flow-specific gameplay feedback.
- `aerobeat-content-core`: durable song-package, song, chart, set, schema, validation, and authored/imported content relationship rules, including Boxing/Flow chart object vocabulary where it is content truth rather than runtime behavior. Canonical schema terminology should migrate from `feature` to `mode` in this wave.
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
- possible dependencies: target `aerobeat-mode-core`, `aerobeat-content-core`, `aerobeat-input-core`, and narrowly any timing/audio contract if needed
- explicit non-goals: no camera lifecycle, no detector logic, no BeatSaver conversion, no UI shell chrome, no environment loading, no concrete feature-specific judgement

The open question is whether this layer earns a new repo now, or whether the first implementation wave can keep the conductor inside `aerobeat-assembly-community` until the shared seam is proven.

### Proposed Dependency Direction

- mode repos -> target `aerobeat-mode-core`
- mode repos -> `aerobeat-content-core` only when they consume chart/content contracts
- mode repos -> `aerobeat-input-core` for intent interfaces and fake/test streams, not concrete camera providers
- concrete input providers -> `aerobeat-input-core`
- `aerobeat-input-camera-tracking` -> `aerobeat-tool-camera-tracking` for normalized tracking frames and provider lifecycle
- vendor repos -> tool repos or concrete provider repos, not feature repos
- tool/content-authoring repos -> `aerobeat-content-core` for contract truth
- assembly/workbench repos -> every concrete package needed to run the slice through GodotEnv

### First Implementation Sequence After Freeze

1. Audit and plan the `feature` -> `mode` rename across repos, code symbols, docs, manifests, dependency keys, GitHub repo names, and serialized content schema.
2. Create `aerobeat-gameplay-runner` using the approved package/testbed shape after comparing against current AeroBeat package repos.
3. Execute the approved in-place repo/template rename and schema migration in a controlled polyrepo wave.
4. Normalize the target Boxing and Flow mode repo testbed manifests around mode-core, content-core, input-core, and GUT/headless validation.
5. Add minimal mode-core DTOs/interfaces for runner contracts, results, timing hooks, and lifecycle vocabulary.
6. Implement mode-local pure rule engines against fixture charts and fake input intent streams before live camera binding.
7. Wire `aerobeat-assembly-community` last through `addons.jsonc` once runner, modes, content contracts, and camera input composition are proven.

### Unresolved Freeze Questions

- What exact compatibility policy should the schema migration use: hard breaking rename only, or accept old `feature` input with warnings while writing canonical `mode` output?
- Should the runner own audio-clock binding and chart timeline dispatch, or delegate clocking to an audio/tool package while only subscribing to timing events?
- Should mode repos expose pure rule engines only, or also package Godot scenes/controllers for their in-game lane visuals?
- For v1, should Boxing and Flow both consume the same `BodyCellInput` lane where possible, or should Boxing primarily consume explicit `BoxingInput` events and reserve body-cell for debug/calibration?
- Should first fixtures come from converted BeatSaver `song-package.yaml` output, hand-authored minimal fixtures, or both?
- Should `aerobeat-assembly-community` be the first integration target immediately, or should the new gameplay runner/workbench prove composition first?

## Proposed `aerobeat-gameplay-runner` Repo Shape

This repo should be a reusable Godot package repo with a hidden `.testbed`, not an assembly app and not a tool repo. The root of the repo must never contain a Godot project or GodotEnv manifest; `.testbed/` is the only place for `project.godot`, `addons.jsonc`, showcase scenes, test UI, and showcase-only media/art assets.

Proposed root structure:

```text
aerobeat-gameplay-runner/
├── .beads/
├── .github/
│   └── workflows/
│       ├── cla.yml
│       └── gut_ci.yml
├── .plans/
├── .testbed/
│   ├── addons.jsonc
│   ├── project.godot
│   ├── assets/
│   │   └── README.md
│   ├── scenes/
│   │   └── gameplay_runner_testbed.tscn
│   └── tests/
│       └── test_gameplay_runner_contract.gd
├── src/
│   ├── AeroGameplayRunner.gd
│   ├── data_types/
│   │   ├── gameplay_run_config.gd
│   │   ├── gameplay_run_result.gd
│   │   └── gameplay_run_state.gd
│   ├── interfaces/
│   │   ├── gameplay_mode_runner.gd
│   │   ├── gameplay_timeline_clock.gd
│   │   └── gameplay_input_stream.gd
│   └── runtime/
│       ├── gameplay_session.gd
│       ├── gameplay_event_dispatcher.gd
│       └── gameplay_score_aggregator.gd
├── .gitignore
├── LICENSE.md
├── README.md
└── plugin.cfg
```

Root constraints:

- no root `project.godot`
- no root `addons.jsonc`
- no root showcase art, UI, screenshots, or fixture media
- root `assets/` is allowed only for real reusable package assets/configs, not testbed presentation
- `.testbed/` follows the package-testbed convention visible in `aerobeat-input-camera-tracking`

Proposed `.testbed/addons.jsonc` local bootstrap:

```jsonc
{
  "$schema": "https://chickensoft.games/schemas/addons.schema.json",
  "addons": {
    "aerobeat-mode-core": {
      "url": "../../aerobeat-mode-core",
      "subfolder": "/",
      "source": "symlink"
    },
    "aerobeat-content-core": {
      "url": "../../aerobeat-content-core",
      "subfolder": "/",
      "source": "symlink"
    },
    "aerobeat-input-core": {
      "url": "../../aerobeat-input-core",
      "subfolder": "/",
      "source": "symlink"
    },
    "aerobeat-tool-audio-player": {
      "url": "../../aerobeat-tool-audio-player",
      "subfolder": "/",
      "source": "symlink"
    },
    "aerobeat-tool-headless-manager": {
      "url": "../../aerobeat-tool-headless-manager",
      "subfolder": "/",
      "source": "symlink"
    },
    "aerobeat-vendor-godot-unit-test": {
      "url": "../../aerobeat-vendor-godot-unit-test",
      "subfolder": "/",
      "source": "symlink"
    }
  }
}
```

Proposed `plugin.cfg`:

```ini
[plugin]

name="AeroBeat Gameplay Runner"
description="Shared song-run orchestration for running AeroBeat content with an approved gameplay mode such as Boxing or Flow."
author="AeroBeat Workouts"
version="0.0.1"
```

Initial non-goals:

- no concrete Boxing or Flow rules
- no camera lifecycle or provider implementation
- no BeatSaver acquisition/conversion
- no menu/UI shell chrome
- no assembly-specific app scenes
- no environment loading beyond accepting future assembly-provided context

## `feature` To `mode` Rename Audit

Read-only audit result: exact `aerobeat-feature-*` references appear in 40 material files outside ignored/generated/cache areas. The active direct rename targets are:

- `aerobeat-feature-core` -> `aerobeat-mode-core`
- `aerobeat-feature-boxing` -> `aerobeat-mode-boxing`
- `aerobeat-feature-flow` -> `aerobeat-mode-flow`
- likely `aerobeat-template-feature` -> `aerobeat-template-mode`

Material update areas:

- GitHub repo names, local folder names, and git remotes.
- GodotEnv addon keys/URLs, especially Flow and template manifests that currently pin `aerobeat-feature-core`; Boxing should be normalized to mode-core during the same dependency cleanup.
- `plugin.cfg` names/descriptions, `.testbed/project.godot` display names, and tests that assert old labels.
- `aerobeat-docs` publishing paths, template docs, generated API source paths, licensing/category docs, and docs navigation from `api/features` toward `api/modes`.
- Product wording in live READMEs and docs that says "gameplay features" when the desired product term is "gameplay modes".
- Current active plans should migrate to mode terminology; archive plans should remain historical except for transition notes when needed.

Approved schema migration:

- `feature` inside `aerobeat-content-core` and `aerobeat-tool-content-authoring` is serialized content/package/chart contract surface today and must migrate to canonical `mode` now.
- The migration affects fixtures, validators, importer output, error codes such as `invalid_feature`, taxonomy docs, package examples, and tests.
- Do not leave legacy `feature` as the canonical field. Any temporary compatibility behavior must be explicit and covered by tests.

Recommended rename sequence:

1. Freeze naming and schema policy: repo/lane terminology becomes `mode`; serialized content field `feature` migrates to canonical `mode` in this wave.
2. Rename GitHub repos in place where possible, update local folders and `origin` remotes, and rely on GitHub redirects only as a temporary cushion.
3. Update GodotEnv manifests/addon keys and validate installs.
4. Update repo-local README/plugin/project/test labels.
5. Update docs/templates/publish tooling, move docs paths from `api/features` to `api/modes` if approved, then regenerate docs.
6. Run the content-schema migration and update importer/tooling/tests/docs so canonical package/chart terminology is `mode`.
7. Validate with exact `rg`, GodotEnv restore/import/GUT in touched repos, and docs build/publish dry run.

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

### Task 4: Audit `feature` To `mode` Rename Impact

**Bead ID:** `afc-enq`
**SubAgent:** `primary`
**Role:** `research`
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-08`, `REF-09`
**Prompt:** You are the `research` role on the `primary` lane for AeroBeat. Claim bead `afc-enq` with `bd update afc-enq --status in_progress --json`. Audit the AeroBeat polyrepo for renaming `feature` terminology to `mode`, including repo names, local folders, GitHub references, README/docs terminology, GodotEnv manifests, addon keys, plugin.cfg names, GDScript class/file names, tests, plans, and CI/scripts. Do not modify code. Update bead `afc-enq` with a migration inventory, ordering risks, and recommended phased rename strategy; do not close the bead.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-08-01-aerobeat-gameplay-architecture-resume.md`

**Status:** Complete

**Results:** Read-only audit completed. Findings are summarized in the `feature` To `mode` Rename Audit section and stored in bead `afc-enq`. Derrick approved in-place repo renames, template rename, and canonical schema migration from `feature` to `mode`; the next step is a concrete execution inventory and ordering plan before repo-wide edits.

---

### Task 5: Confirm `aerobeat-gameplay-runner` Repo Shape

**Bead ID:** `afc-67x`
**SubAgent:** `primary`
**Role:** `research`
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-08`, `REF-09`
**Prompt:** You are the `research` role on the `primary` lane for AeroBeat. Claim bead `afc-67x` with `bd update afc-67x --status in_progress --json`. Inspect current AeroBeat template/package repos and propose the exact folder/file structure for `aerobeat-gameplay-runner`. Do not create the GitHub repo or local repo. Update bead `afc-67x` with the proposed structure and confirmation checklist; do not close the bead until Derrick confirms.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-08-01-aerobeat-gameplay-architecture-resume.md`

**Status:** Complete

**Results:** Derrick approved the runner concept and repo structure, with the added constraint that the root must not contain GodotEnv or Godot project files. `.testbed/` may contain the Godot project, showcase art/UI, scenes, and validation fixtures. The next step is to generate the GitHub repo and local package scaffold in the approved shape.

---

### Task 6: Prepare Rename And Schema Migration Execution Inventory

**Bead ID:** `afc-fzs`
**SubAgent:** `primary`
**Role:** `research`
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-06`, `REF-08`, `REF-09`
**Prompt:** You are the `research` role on the `primary` lane for AeroBeat. Claim bead `afc-fzs` with `bd update afc-fzs --status in_progress --json`. Audit the approved `feature` -> `mode` rename execution wave across AeroBeat repos. Include in-place GitHub repo renames, local folder/remotes, `aerobeat-template-feature` rename, docs path changes, GodotEnv manifests, Godot plugin/project labels, code symbols, tests, and the now-approved serialized schema migration from canonical `feature` to `mode`. Do not modify code. Produce an ordered execution checklist with risk notes and validation commands, then update bead `afc-fzs` with the inventory. Do not close the bead unless the inventory is complete enough for implementation planning.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-08-01-aerobeat-gameplay-architecture-resume.md`

**Status:** In Progress

**Results:** Spawned `primary` research subagent `aerobeat_mode_rename_inventory` to produce the ordered rename/schema execution inventory. Awaiting subagent completion.

---

### Task 7: Generate `aerobeat-gameplay-runner` Repo

**Bead ID:** `afc-nfq`
**SubAgent:** `primary`
**Role:** `coder`
**References:** `REF-07`, `REF-08`, `REF-10`
**Prompt:** You are the `coder` role on the `primary` lane for AeroBeat. Claim bead `afc-nfq` with `bd update afc-nfq --status in_progress --json`. Create the `aerobeat-gameplay-runner` GitHub repo and local package scaffold using the approved shape. Match existing AeroBeat package conventions, especially the hidden `.testbed/` Godot project pattern from `aerobeat-input-camera-tracking`. The root must not contain `project.godot` or `addons.jsonc`; `.testbed/` owns GodotEnv, showcase scenes/UI/art, and tests. Commit and push the initial scaffold.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-gameplay-runner/`

**Files Created/Deleted/Modified:**
- `Pending coder output`

**Status:** In Progress

**Results:** Spawned `primary` coder subagent `aerobeat_gameplay_runner_scaffold` to create the GitHub repo and local scaffold using the approved root/package and hidden `.testbed` shape. Awaiting subagent completion.

---

## Final Results

**Status:** Pending

**What We Built:** Architecture discussion plan and beads initialized. Runner boundary approved; rename audit and runner repo structure confirmation are now active. Implementation and GitHub repo generation remain deferred until Derrick confirms the scaffold shape.

**Reference Check:** Research checked current feature, input, content, tool/vendor, assembly, environment, UI, docs, and handoff references. Derrick freeze decision pending.

**Commits:**
- Pending

**Lessons Learned:** Pending

---

*Drafted on 2026-08-01*
