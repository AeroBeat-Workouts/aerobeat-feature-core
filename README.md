# aerobeat-mode-core

Shared AeroBeat gameplay-mode and runtime-rule contracts that interpret athlete actions against authored content over time.

## Architecture role

`aerobeat-mode-core` is the lane owner for reusable mode/runtime contracts. It exists so AeroBeat gameplay modes can share stable mode-facing types and rule surfaces without depending on unrelated input, content, asset, UI, or tool concerns.

## V1 scope stance

The official AeroBeat v1 gameplay modes are **boxing** and **flow**.

This repo should keep active mode contracts focused on those current product lanes first while preserving room for later expansion:

- **Current first-class mode consumers:** Boxing and Flow
- **Current priority:** reusable gameplay-mode and runtime-rule contracts for the active PC-first, camera-first product slice
- **Future expansion space:** additional gameplay modes can build on the same lane later
- **Not current active v1 truth:** removed or inactive modes such as Dance and Step should not be presented as present-tense first-class consumers

## Lane boundaries

This repo intentionally owns:

- shared gameplay-mode vocabulary
- runtime-rule and mode-state contracts
- mode-facing DTOs, enums, and interfaces reused across multiple gameplay modes
- narrowly shared seams that active mode repos can build on without redefining the same rule vocabulary

This repo intentionally does **not** own:

- concrete input-provider detection logic
- authored content/package schemas
- product asset definitions
- UI shell presentation, widgets, or menu behavior
- app-specific tool workflows or automation surfaces

## Current repository contents

Current checked-in code is intentionally centered on the portable v1 mode contract minimum:

- `ModeDescriptor`: portable mode identity, display keys, supported chart/input contracts, and mode contract version
- `ModeRunConfig`: the mode-local setup subset a runner or mode fixture passes into a rule engine
- `ModeRunner`: lifecycle interface for pure rule engines: `get_descriptor()`, `start(config)`, `tick(frame)`, `is_complete()`, and `stop(reason)`
- `ModeTickFrame`: per-tick timeline position/delta plus due chart events and normalized input events
- `ModeEvent`, `ModeJudgementEvent`, and `ModeScoreDelta`: mode-produced event, judgement, and scoring fragments
- `ModeRunFragment`: mode-produced lifecycle/summary fragments that a runner can wrap into session results
- `ModeFixtureCase`: tiny fixture contract shape for mode-local rule tests
- `.testbed/`: hidden package workbench with focused GUT contract tests

The public contract surface stays data-oriented and runner-agnostic. It does not include session envelopes, clocks, fake input stream implementations, testbed transport, camera/provider debug payloads, raw landmark processing, score aggregation, product UI, or assembly composition.

## Intended consumers

The active `aerobeat-mode-boxing` and `aerobeat-mode-flow` repos should depend on this package for shared mode-lane contracts before composing only the adjacent lane contracts they actually use.

## Development and validation

Current validation is through the hidden package testbed:

```bash
/home/derrick/.openclaw/workspace/scripts/godotenv-sync --repo /home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-mode-core
godot --headless --path .testbed --import
godot --headless --path .testbed --script addons/aerobeat-vendor-godot-unit-test/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit
```

## Repository status

This repo is the canonical home for shared Mode-lane contracts in the current AeroBeat v1 architecture. As the lane fills out, keep the public contract surface narrowly focused on gameplay/runtime rules for active v1 modes first, while preserving room for future extensibility instead of turning the repo into a universal project hub.
