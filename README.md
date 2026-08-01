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

Current checked-in content is intentionally minimal:

- the repo is presently a lane-definition and contract-home placeholder
- no broader runtime/testbed harness is checked in yet
- future checked-in code here should stay centered on mode-common rule contracts rather than becoming a catch-all gameplay implementation repo

## Intended consumers

The active `aerobeat-mode-boxing` and `aerobeat-mode-flow` repos should depend on this package for shared mode-lane contracts before composing only the adjacent lane contracts they actually use.

## Development and validation

Current validation for this README-normalization pass is intentionally lightweight:

- verify the README matches the shared six-core skeleton
- verify the wording stays lane-correct against the architecture docs
- verify the repo does not overclaim inactive modes or unrelated lane ownership

At the moment, no repo-local hidden testbed or automated contract harness is checked in here.

## Repository status

This repo is the canonical home for shared Mode-lane contracts in the current AeroBeat v1 architecture. As the lane fills out, keep the public contract surface narrowly focused on gameplay/runtime rules for active v1 modes first, while preserving room for future extensibility instead of turning the repo into a universal project hub.
