# aerobeat-feature-core

Shared AeroBeat gameplay-mode and runtime-rule contracts that interpret athlete actions against authored content over time.

## Architecture role

`aerobeat-feature-core` is the lane owner for reusable feature/runtime contracts. It exists so concrete gameplay repos can share stable feature-facing types without depending on unrelated input, UI, asset, or tool concerns.

## Intended consumers

Feature implementations such as boxing, dance, step, and flow should depend on this repo for shared runtime contracts, then compose any adjacent lane contracts they actually consume.

## Repository status

This repo is the canonical home for shared feature-lane contracts in the six-core AeroBeat architecture. As the lane fills out, keep the public contract surface narrowly focused on gameplay/runtime rules rather than turning the repo into a universal project hub.
