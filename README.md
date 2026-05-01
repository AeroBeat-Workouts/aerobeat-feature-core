# aerobeat-feature-core

Shared AeroBeat gameplay-mode and runtime-rule contracts that interpret athlete actions against authored content over time.

## Architecture role

`aerobeat-feature-core` is the lane owner for reusable feature/runtime contracts. It exists so AeroBeat gameplay features can share stable feature-facing types and rule surfaces without depending on unrelated input, UI, asset, or tool concerns.

## Intended consumers

The official AeroBeat v1 gameplay features are **boxing** and **flow**, and those active feature repos should depend on this package for shared runtime contracts before composing any adjacent lane contracts they actually consume.

Future feature expansion can still build on the same shared lane, but removed modes such as **dance** and **step** are not current first-class consumers in the active v1 scope.

## Repository status

This repo is the canonical home for shared feature-lane contracts in the current AeroBeat v1 architecture. As the lane fills out, keep the public contract surface narrowly focused on gameplay/runtime rules for active v1 features first, while preserving room for future extensibility instead of turning the repo into a universal project hub.
