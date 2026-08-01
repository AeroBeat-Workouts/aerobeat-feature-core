# AeroBeat Gameplay Architecture Resume

**Date:** 2026-08-01
**Status:** In Progress
**Last Updated:** 2026-08-01 17:47 EDT
**Blocked Reason:** Pending Derrick architecture freeze decisions for bead `afc-n5l`; implementation planning should not advance until the gameplay boundaries and next implementation slice are explicitly frozen. Current freeze prompt is whether to accept or change the six recommended defaults for runner ownership, audio-clock delegation, pure mode rule engines plus optional workbenches, explicit Boxing/Flow input contracts, dual fixture strategy, and runner `.testbed` integration before assembly integration.
**Agent:** pico

---

## Goal

Freeze the next AeroBeat gameplay mode architecture by mapping mode, content, input, assembly, and possible new gameplay-boundary repo responsibilities before any Boxing or Flow implementation begins.

---

## Overview

The latest AeroBeat handoff says the previous camera/input proving-scenes cleanup wave is complete and archived. There is no active implementation plan to resume; the next slice is a fresh gameplay architecture planning pass.

This plan now uses the renamed `aerobeat-mode-core` repo as the owning repo. It is the canonical home for shared gameplay-mode and runtime-rule contracts. The planning pass should inspect the active gameplay repos, input contract repos, maps/content repos, assembly workbench shape, and any missing repo boundaries, then produce a concrete responsibility split for the first gameplay implementation wave.

This is primarily a discussion-first execution slice. No implementation work should start until the architecture split is explicit, the mode repo boundaries are agreed and frozen, the input-repo dependency shape is clear, and Derrick approves the next implementation plan. AeroBeat is a polyrepo project, so a clean new repo boundary is preferred over stuffing unrelated gameplay concerns into the Boxing, Flow, or shared mode contract repos.

Derrick approved the `aerobeat-gameplay-runner` boundary: the runner is where AeroBeat runs a song with either Boxing or Flow gameplay, while the rules for those modes stay in the gameplay-mode repos. During this same architecture section, Derrick also approved renaming `feature` terminology to `mode` terminology across the AeroBeat polyrepo before implementation begins.

Approved rename decisions:

- Rename existing GitHub repos in place rather than creating replacement repos.
- Rename the original feature-named gameplay repos in place to `aerobeat-mode-core`, `aerobeat-mode-boxing`, and `aerobeat-mode-flow`.
- Rename the original feature template repo in place to `aerobeat-template-mode` in the same wave.
- Migrate serialized content/package/chart schema fields from `feature` to `mode` now; do not keep the legacy field as the canonical contract.
- Treat compatibility/fixtures/importer/test updates as part of the schema migration rather than a deferred cleanup.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Latest recovered AeroBeat handoff | `/home/derrick/.openclaw/workspace/projects/openclaw-pico/handoffs/handoff-2026-07-31T13-51-00-04-00-aerobeat.md` |
| `REF-02` | Shared Mode-lane contract home | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-core/README.md` |
| `REF-03` | Active Boxing mode repo truth | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-boxing/README.md` |
| `REF-04` | Active Flow mode repo truth | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-flow/README.md` |
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

- `aerobeat-mode-core`: shared gameplay-mode vocabulary, runtime-rule interfaces, mode lifecycle/state/scoring result contracts, and cross-mode rule seams reused by Boxing and Flow.
- `aerobeat-mode-boxing`: Boxing-specific chart interpretation, hit-window/rule evaluation, scoring semantics, combo/streak behavior, Boxing workbench scenes/tests, and any Boxing-specific visuals that are part of gameplay feedback.
- `aerobeat-mode-flow`: Flow-specific chart interpretation, grid/object/rule evaluation, scoring semantics, Flow workbench scenes/tests, and Flow-specific gameplay feedback.
- `aerobeat-content-core`: durable song-package, song, chart, set, schema, validation, and authored/imported content relationship rules, including Boxing/Flow chart object vocabulary where it is content truth rather than runtime behavior. Canonical schema terminology should migrate from `feature` to `mode` in this wave.
- `aerobeat-input-core`: stable provider/session/intent contracts, `BoxingInput`, `FlowInput`, `BodyCellInput`, UI interaction bridge contracts, and normalized lifecycle seams.
- `aerobeat-tool-camera-tracking`: vendor-agnostic camera lifecycle, source selection, preview ownership, backend resolution, and normalized tracking-frame publication.
- `aerobeat-input-camera-tracking`: camera gameplay interpretation layer that turns normalized `CameraTracking` frames into current Boxing/Flow input intents; it owns detector truth and should stay below mode rule evaluation.
- concrete input repos: device/provider packages that bridge hardware/runtime details into `aerobeat-input-core` contracts; future providers remain future until promoted.
- `aerobeat-tool-content-authoring` and `aerobeat-vendor-beatsaver`: acquisition, staging, conversion, and authoring workflows; they should emit/validate content through `aerobeat-content-core` rather than own runtime gameplay behavior.
- `aerobeat-assembly-community`: runnable PC community app composition, dependency pinning, camera sidecar packaging, product scenes, and integration tests.

### New Repo Boundary Under Discussion

There appears to be a clean potential boundary for a shared gameplay session/runner layer that should not be stuffed into mode repos:

- recommended name: `aerobeat-gameplay-runner`
- fallback names if Derrick dislikes that shape: `aerobeat-runtime-gameplay` or `aerobeat-gameplay-core`
- owner role: runtime composition state that is neither pure mode contract nor Boxing/Flow-specific logic
- concrete responsibilities: selected song package/chart, active mode runner selection, timeline clock binding to audio, input subscription wiring, event dispatch, per-session lifecycle, pause/resume/retry, common gameplay result envelope, and assembly-facing scene/controller glue
- possible consumers: assemblies, mode workbenches, and future product-specific clients
- possible dependencies: target `aerobeat-mode-core`, `aerobeat-content-core`, `aerobeat-input-core`, and narrowly any timing/audio contract if needed
- explicit non-goals: no camera lifecycle, no detector logic, no BeatSaver conversion, no UI shell chrome, no environment loading, no concrete mode-specific judgement

The open question is whether this layer earns a new repo now, or whether the first implementation wave can keep the conductor inside `aerobeat-assembly-community` until the shared seam is proven.

### Proposed Dependency Direction

- mode repos -> target `aerobeat-mode-core`
- mode repos -> `aerobeat-content-core` only when they consume chart/content contracts
- mode repos -> `aerobeat-input-core` for intent interfaces and fake/test streams, not concrete camera providers
- concrete input providers -> `aerobeat-input-core`
- `aerobeat-input-camera-tracking` -> `aerobeat-tool-camera-tracking` for normalized tracking frames and provider lifecycle
- vendor repos -> tool repos or concrete provider repos, not mode repos
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

Read-only audit result from before Task 10 found exact legacy `aerobeat-feature-*` references in 40 material files outside ignored/generated/cache areas. The direct rename targets were:

- shared mode core repo -> `aerobeat-mode-core`
- Boxing mode repo -> `aerobeat-mode-boxing`
- Flow mode repo -> `aerobeat-mode-flow`
- gameplay mode template repo -> `aerobeat-template-mode`

Material update areas:

- GitHub repo names, local folder names, and git remotes.
- GodotEnv addon keys/URLs, especially Flow and template manifests that pinned the shared core repo; Boxing should be normalized to mode-core during the same dependency cleanup.
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
**Prompt:** You are the `research` role on the `primary` lane for AeroBeat. Claim bead `afc-n5l` with `bd update afc-n5l --status in_progress --json`. Inspect the active AeroBeat gameplay, content/maps, input, and assembly repos needed to decide first implementation ownership. Summarize current repo responsibilities, package/testbed state, dependency contracts, and any missing repo boundaries. Pay special attention to what belongs in mode repos, what does not, and how mode repos should use input repos. Do not implement code. Update bead `afc-n5l` with findings; do not close it.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-08-01-aerobeat-gameplay-architecture-resume.md`

**Status:** Complete

**Results:** Research pass completed and wrote proposal details into bead `afc-n5l`. Repo boundary findings are summarized in the Working Boundary Proposal. Implementation remains out of scope until the architecture is frozen.

---

### Task 2: Draft Architecture Freeze Proposal

**Bead ID:** `afc-n5l`
**SubAgent:** `primary`
**Role:** `research`
**References:** `REF-02`, `REF-03`, `REF-04`
**Prompt:** You are the `research` role on the `primary` lane for AeroBeat architecture documentation. Using the Task 1 findings, draft a discussion-ready architecture freeze proposal that defines the first implementation split across `aerobeat-mode-core`, `aerobeat-mode-boxing`, `aerobeat-mode-flow`, `aerobeat-content-core`, input repos, assembly/workbench repos, and any recommended new repos. Keep the output to architecture, repo boundaries, dependency direction, and execution sequencing only; do not implement runtime mode code. Update bead `afc-n5l` with the proposal; do not close it.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-08-01-aerobeat-gameplay-architecture-resume.md`

**Status:** In Review

**Results:** Drafted proposal now recommends `aerobeat-gameplay-runner` as the shared gameplay orchestration boundary rather than placing session/timeline/input/content/mode composition in mode-core, concrete mode repos, or the PC community assembly.

---

### Task 3: Derrick Architecture Review And Freeze Gate

**Bead ID:** `afc-n5l`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** You are the `auditor` role on the `primary` lane for AeroBeat. After Derrick reviews the proposal, verify that the frozen architecture is reflected in the plan, that implementation remains blocked until the freeze is explicit, and that any future implementation beads are clearly separated from this architecture bead. Confirm the plan does not reintroduce inactive Dance/Step language, does not blur mode/content/input/tool boundaries, and identifies any new repo creation boundary if needed. If Derrick freezes the architecture and the plan reflects it, close bead `afc-n5l` with the reason; otherwise leave it open with the exact unresolved decisions.

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
**Prompt:** You are the `research` role on the `primary` lane for AeroBeat. Claim bead `afc-fzs` with `bd update afc-fzs --status in_progress --json`. Audit the approved `feature` -> `mode` rename execution wave across AeroBeat repos. Include in-place GitHub repo renames, local folder/remotes, `aerobeat-template-mode` rename, docs path changes, GodotEnv manifests, Godot plugin/project labels, code symbols, tests, and the now-approved serialized schema migration from canonical `feature` to `mode`. Do not modify code. Produce an ordered execution checklist with risk notes and validation commands, then update bead `afc-fzs` with the inventory. Do not close the bead unless the inventory is complete enough for implementation planning.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-08-01-aerobeat-gameplay-architecture-resume.md`

**Status:** Complete

**Results:** Completed read-only ordered execution inventory in bead `afc-fzs` and closed the bead. Inventory covers in-place GitHub/local repo renames, `aerobeat-template-mode` rename, GodotEnv manifests, docs/API path moves, README/plugin/project label updates, `ContentFeature`/`content_feature` rename, canonical serialized `feature` -> `mode` schema migration, `invalid_feature`/`chart_descriptor_feature_mismatch` error-code migration, fixtures, importer/tooling output, and validation commands. Main risk: `aerobeat-content-core` and `aerobeat-tool-content-authoring` must migrate in the same implementation wave or authoring/import tooling will keep emitting legacy canonical `feature` fields after validators expect `mode`.

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

**Status:** Complete

**Results:** Created and pushed `aerobeat-gameplay-runner` to `https://github.com/AeroBeat-Workouts/aerobeat-gameplay-runner` at commit `a862f27` (`Create gameplay runner scaffold`). Orchestrator verified local checkout is on `main...origin/main`, root has no `project.godot` and no `addons.jsonc`, and `.testbed/` contains the Godot project and GodotEnv manifest. Coder validation reported `godotenv addons install`, Godot headless import, and GUT passing 1 script / 1 test / 9 assertions, with existing vendored GUT UID fallback warnings plus Godot exit leak warning.

---

### Task 8: QA Verify `aerobeat-gameplay-runner` Scaffold

**Bead ID:** `afc-p0z`
**SubAgent:** `primary`
**Role:** `qa`
**References:** `REF-07`, `REF-08`, `REF-10`
**Prompt:** You are the `qa` role on the `primary` lane for AeroBeat. Claim bead `afc-p0z` with `bd update afc-p0z --status in_progress --json`. Independently verify the `aerobeat-gameplay-runner` scaffold after coder handoff. Confirm remote/commit, root has no `project.godot` or `addons.jsonc`, `.testbed` owns Godot project/GodotEnv/test assets, GodotEnv install/import/GUT validation passes or failures are documented, and repo is clean/up to date. Update and close bead `afc-p0z` when QA is complete.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-gameplay-runner/`

**Files Created/Deleted/Modified:**
- `Pending QA output`

**Status:** Complete

**Results:** QA passed and closed bead `afc-p0z`. Evidence: runner remote is `git@github.com:AeroBeat-Workouts/aerobeat-gameplay-runner.git`, branch `main`, HEAD `a862f27d14d1d9e15691dac1ac1487cc75921097` matches `origin/main`; root has no `project.godot`, no `addons.jsonc`, and no GodotEnv manifest; `.testbed/` owns `project.godot`, `addons.jsonc`, scenes, tests, and showcase asset note; `godotenv addons install`, Godot headless import, and GUT passed with 1 script / 1 test / 9 assertions. Repo ended clean and up to date.

---

### Task 9: Audit `aerobeat-gameplay-runner` Scaffold Completion

**Bead ID:** `afc-3d9`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-07`, `REF-08`, `REF-10`
**Prompt:** You are the `auditor` role on the `primary` lane for AeroBeat. Claim bead `afc-3d9` with `bd update afc-3d9 --status in_progress --json` after QA bead `afc-p0z` is closed. Independently audit that the runner scaffold satisfies the approved plan, bead `afc-nfq` notes, QA evidence, and root/testbed constraints. Close bead `afc-3d9` only if completion is truthful and pushed.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-gameplay-runner/`

**Files Created/Deleted/Modified:**
- `Pending auditor output`

**Status:** Complete

**Results:** Audit passed and closed bead `afc-3d9`. Evidence checked: runner remote is `git@github.com:AeroBeat-Workouts/aerobeat-gameplay-runner.git`; local HEAD and `origin/main` both point to `a862f27d14d1d9e15691dac1ac1487cc75921097`; root has no `project.godot`, no `addons.jsonc`, and no root GodotEnv manifest; `.testbed/` owns `project.godot`, `addons.jsonc`, showcase scene, tests, and `assets/README.md`; root package shape matches the approved package-only scaffold; `godotenv addons install`, headless import, and GUT validation passed; repo status is clean and up to date.

---

### Task 10: Execute In-Place Mode Repo Rename

**Bead ID:** `afc-b1o`
**SubAgent:** `primary`
**Role:** `coder`
**References:** `REF-02`, `REF-03`, `REF-04`
**Prompt:** You are the `coder` role on the `primary` lane for AeroBeat. Claim bead `afc-b1o` with `bd update afc-b1o --status in_progress --json`. Execute the approved in-place rename for the feature-named core, Boxing, Flow, and template repos to `aerobeat-mode-core`, `aerobeat-mode-boxing`, `aerobeat-mode-flow`, and `aerobeat-template-mode`. Rename GitHub repos in place, local folders, origin remotes, repo-local README/plugin/project labels, GodotEnv manifest references, and the active plan path as needed. Do not perform `aerobeat-content-core` serialized schema migration in this bead. Commit and push touched repos. Update and close bead `afc-b1o` from the new `aerobeat-mode-core` path when complete.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-core/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-boxing/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-flow/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-template-mode/`

**Files Created/Deleted/Modified:**
- `Pending coder output`

**Status:** Complete

**Results:** Completed in-place GitHub/local rename wave and focused repair. GitHub repos and local folders now use `aerobeat-mode-core`, `aerobeat-mode-boxing`, `aerobeat-mode-flow`, and `aerobeat-template-mode`. Pushed commits: mode-core `65b4edb` then repair `912ae79`; mode-boxing `d80286b` then repair `0106a50`; mode-flow `1857699` then repair `795e02a`; template-mode `0fa83f0`. Orchestrator verification confirmed all four repos are clean on `main...origin/main`, remotes point to renamed GitHub repos, GitHub repo views resolve, local feature-named folders are gone, and residual active old-name scan only reports historical audit notes in this plan. Serialized content schema migration was intentionally not touched in this bead.

---

### Task 11: QA Verify Mode Repo Rename Wave

**Bead ID:** `afc-qrj`
**SubAgent:** `primary`
**Role:** `qa`
**References:** `REF-02`, `REF-03`, `REF-04`
**Prompt:** You are the `qa` role on the `primary` lane for AeroBeat. Claim bead `afc-qrj` with `bd update afc-qrj --status in_progress --json`. Independently verify the in-place mode repo rename wave: GitHub repos, local folders/remotes, commits, clean statuses, residual old-name scans, active label/test updates, and confirmation that `aerobeat-content-core` and `aerobeat-tool-content-authoring` schema were not changed in this bead. Update and close bead `afc-qrj` if QA passes.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-core/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-boxing/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-flow/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-template-mode/`

**Files Created/Deleted/Modified:**
- `Pending QA output`

**Status:** Complete

**Results:** QA passed and closed bead `afc-qrj` at 2026-08-01 16:25 EDT. Evidence from the bead: renamed GitHub repos resolve, local folders/remotes/main/HEADs are clean and pushed, expected commits are present, old feature folders are absent, active identity scan has only historical plan-note matches, and `aerobeat-content-core` plus `aerobeat-tool-content-authoring` remained untouched.

---

### Task 12: Audit Mode Repo Rename Wave

**Bead ID:** `afc-dog`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-02`, `REF-03`, `REF-04`
**Prompt:** You are the `auditor` role on the `primary` lane for AeroBeat. Claim bead `afc-dog` with `bd update afc-dog --status in_progress --json` after QA bead `afc-qrj` is closed. Independently audit the mode repo rename wave against the plan, bead `afc-b1o`, QA evidence, GitHub repo state, local folders/remotes, and residual reference scans. Close bead `afc-dog` only if the rename is truthful and pushed.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-core/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-boxing/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-flow/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-template-mode/`

**Files Created/Deleted/Modified:**
- `Pending auditor output`

**Status:** Complete

**Results:** Audit passed and closed bead `afc-dog` at 2026-08-01 16:29 EDT. Evidence checked: GitHub repos resolve under the approved `aerobeat-mode-*` and `aerobeat-template-mode` names, old GitHub names redirect to renamed repos, local old folders are absent, new folders/remotes are renamed, all four checkouts are clean on `main` with `HEAD == origin/main`, expected rename commits are pushed, residual exact old-name scans outside archive/history are clean, and remaining active-plan `feature` mentions are explicit audit/schema-migration narrative rather than live repo identity. The auditor correctly scoped this bead to the in-place repo/template rename wave; serialized content schema migration remains a separate approved slice.

---

### Task 13: Execute Canonical Content Schema Migration

**Bead ID:** `aerobeat-content-core-v28`
**SubAgent:** `primary`
**Role:** `coder`
**References:** `REF-06`
**Prompt:** You are the `coder` role on the `primary` lane for AeroBeat. Claim bead `aerobeat-content-core-v28` in `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core` with `bd update aerobeat-content-core-v28 --status in_progress --json`. Migrate canonical AeroBeat serialized content/package/chart schema terminology from `feature` to `mode` across `aerobeat-content-core` and `aerobeat-tool-content-authoring`. Update validators, DTO names as appropriate, fixtures, tests, importer/tooling output, docs/examples, and error codes such as `invalid_feature` / `chart_descriptor_feature_mismatch` to mode terminology. Do not keep legacy `feature` as canonical output; any temporary read compatibility must be explicit and tested. Run relevant repo validations, commit and push touched repos, and update/close the bead when complete. Note that Beads Dolt auto-push is currently warning with `no common ancestor`; do not treat code push success as bead push success.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-content-authoring/`

**Files Created/Deleted/Modified:**
- `Pending coder output`

**Status:** Complete

**Results:** Coder completed and closed bead `aerobeat-content-core-v28` at 2026-08-01 16:37 EDT. Implemented a hard-breaking serialized schema migration with no legacy `feature` read compatibility. Pushed commits: `aerobeat-content-core` `b383c6c` (`Migrate content schema feature field to mode`) and `aerobeat-tool-content-authoring` `7673d03` (`Migrate authoring chart field to mode`). Validation reported: content-core contract tests passed with `godot --headless --path .testbed --script res://../tests/run_contract_tests.gd`; authoring tool tests passed with `godot --headless --path .testbed --script scripts/tests/run_tool_tests.gd` with existing Godot shutdown resource leak warnings and exit code 0; `git diff --check` passed in both repos. Orchestrator spot-check confirmed both repos are clean/even with origin and the focused residual scan for canonical serialized `feature`, old error names, and old type/file names returned no matches.

---

### Task 14: QA Verify Canonical Content Schema Migration

**Bead ID:** `aerobeat-content-core-56d`
**SubAgent:** `primary`
**Role:** `qa`
**References:** `REF-06`
**Prompt:** You are the `qa` role on the `primary` lane for AeroBeat. Claim bead `aerobeat-content-core-56d` in `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core` with `bd update aerobeat-content-core-56d --status in_progress --json` after implementation bead `aerobeat-content-core-v28` is closed. Independently verify the canonical `feature` to `mode` schema migration. Check `aerobeat-content-core` and `aerobeat-tool-content-authoring` diffs, tests, fixtures, docs/examples, importer output, validation errors, residual `feature` scans, clean pushed git state, and that legacy `feature` is not the canonical serialized field. Update and close the bead if QA passes.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-content-authoring/`

**Files Created/Deleted/Modified:**
- `Pending QA output`

**Status:** Complete

**Results:** QA passed and closed bead `aerobeat-content-core-56d` at 2026-08-01 16:41 EDT. Evidence checked: `aerobeat-content-core` clean at `HEAD == origin/main == b383c6c`; `aerobeat-tool-content-authoring` clean at `HEAD == origin/main == 7673d03`; canonical serialized chart/package/chart-descriptor field is now `mode`; active code no longer accepts/writes legacy `feature` as canonical schema; targeted scans found no active `feature` reads/writes, old error codes, `ContentFeature`, `content_feature`, or `VALID_FEATURES`; remaining `feature` hits are unrelated `featuredCoaches`, Godot `config/features`, or archived plan text. QA re-ran content-core contract tests, authoring tool tests, and `git diff --check` in both repos successfully. Godot cleanup warnings in authoring test output were not treated as schema migration failures.

---

### Task 15: Audit Canonical Content Schema Migration

**Bead ID:** `aerobeat-content-core-5sd`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-06`
**Prompt:** You are the `auditor` role on the `primary` lane for AeroBeat. Claim bead `aerobeat-content-core-5sd` in `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core` with `bd update aerobeat-content-core-5sd --status in_progress --json` after QA bead `aerobeat-content-core-56d` is closed. Independently audit the canonical `feature` to `mode` schema migration against this active plan, implementation bead `aerobeat-content-core-v28`, QA bead `aerobeat-content-core-56d`, diffs, validation evidence, residual scans, and pushed repo state. Close only if the schema migration is truthful, complete, and pushed.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-content-authoring/`

**Files Created/Deleted/Modified:**
- `Pending auditor output`

**Status:** Complete

**Results:** Audit passed and closed bead `aerobeat-content-core-5sd` at 2026-08-01 16:44 EDT. Evidence checked: `aerobeat-content-core` clean at `HEAD == origin/main == b383c6c`; `aerobeat-tool-content-authoring` clean at `HEAD == origin/main == 7673d03`; active code/fixtures/docs now use `mode` as the canonical serialized field for charts, package chart descriptors, content queries, validators, tests, YAML codec, DTO/write paths, and BeatSaver/external importer output; targeted scans found no material legacy canonical `feature` field, old error names, `ContentFeature`, `content_feature`, `VALID_FEATURES`, or feature-named files; remaining `feature` mentions are unrelated `featuredCoaches` / featured coach metadata. Auditor re-ran content-core contract tests, authoring tool tests, and `git diff --check` successfully. Known Godot resource cleanup warnings remain non-blocking because tests exit 0. Beads/Dolt `no common ancestor` remains a tracking-storage caveat, not a code/schema completion gap; filed follow-up bead `aerobeat-content-core-gyn`.

---

## Final Results

**Status:** Pending

**What We Built:** Architecture discussion plan and beads initialized. Runner boundary and repo structure were approved; `aerobeat-gameplay-runner` was generated and audited. The in-place `feature` repo/template rename to `mode` was implemented, QA verified, audited, committed, and pushed. Canonical serialized content schema migration from `feature` to `mode` was implemented as a hard-breaking migration, QA verified, audited, committed, and pushed.

**Reference Check:** Research checked current mode, input, content, tool/vendor, assembly, environment, UI, docs, and handoff references. Derrick approved the runner boundary, root/testbed shape, in-place mode repo rename, template rename, and canonical schema migration. Final architecture freeze for gameplay implementation is still pending discussion.

**Commits:**
- `a862f27` - Create gameplay runner scaffold (`aerobeat-gameplay-runner`)
- `d8bee6a` - Current `aerobeat-mode-core` repo rename head before plan updates
- `0106a50` - Current `aerobeat-mode-boxing` repo rename head
- `795e02a` - Current `aerobeat-mode-flow` repo rename head
- `0fa83f0` - Current `aerobeat-template-mode` repo rename head
- `b383c6c` - Migrate content schema feature field to mode (`aerobeat-content-core`)
- `7673d03` - Migrate authoring chart field to mode (`aerobeat-tool-content-authoring`)
- `085efe3` - Update AeroBeat mode migration plan (`aerobeat-mode-core`)
- `34d8fae` - Record AeroBeat schema migration handoff (`aerobeat-mode-core`)
- `a1ae07b` - Record AeroBeat schema migration QA (`aerobeat-mode-core`)

**Lessons Learned:** Keep repo identity rename, serialized schema migration, and Beads storage repair as separate beads even when they are part of one terminology wave; it made QA/audit scope much cleaner.

---

*Drafted on 2026-08-01*
