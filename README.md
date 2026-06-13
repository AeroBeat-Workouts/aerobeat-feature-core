# aerobeat-feature-core

Shared AeroBeat gameplay-mode and runtime-rule contracts that interpret athlete actions against authored content over time.

## Architecture role

`aerobeat-feature-core` is the lane owner for reusable feature/runtime contracts. It exists so AeroBeat gameplay features can share stable feature-facing types and rule surfaces without depending on unrelated input, content, asset, UI, or tool concerns.

## V1 scope stance

The official AeroBeat v1 gameplay features are **boxing** and **flow**.

This repo should keep active feature contracts focused on those current product lanes first while preserving room for later expansion:

- **Current first-class feature consumers:** Boxing and Flow
- **Current priority:** reusable gameplay-mode and runtime-rule contracts for the active PC-first, camera-first product slice
- **Future expansion space:** additional gameplay features can build on the same lane later
- **Not current active v1 truth:** removed or inactive modes such as Dance and Step should not be presented as present-tense first-class consumers

## Lane boundaries

This repo intentionally owns:

- shared gameplay-mode vocabulary
- runtime-rule and feature-state contracts
- feature-facing DTOs, enums, and interfaces reused across multiple gameplay features
- narrowly shared seams that active feature repos can build on without redefining the same rule vocabulary

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
- future checked-in code here should stay centered on feature-common rule contracts rather than becoming a catch-all gameplay implementation repo

## Intended consumers

The active `aerobeat-feature-boxing` and `aerobeat-feature-flow` repos should depend on this package for shared feature-lane contracts before composing only the adjacent lane contracts they actually use.

## Development and validation

Current validation for this README-normalization pass is intentionally lightweight:

- verify the README matches the shared six-core skeleton
- verify the wording stays lane-correct against the architecture docs
- verify the repo does not overclaim inactive features or unrelated lane ownership

At the moment, no repo-local hidden testbed or automated contract harness is checked in here.

## Repository status

This repo is the canonical home for shared Feature-lane contracts in the current AeroBeat v1 architecture. As the lane fills out, keep the public contract surface narrowly focused on gameplay/runtime rules for active v1 features first, while preserving room for future extensibility instead of turning the repo into a universal project hub.
