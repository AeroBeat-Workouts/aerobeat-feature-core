class_name ModeRunner
extends RefCounted
## Interface documentation for pure AeroBeat gameplay mode runners.
##
## Expected concrete methods:
## - get_descriptor() -> ModeDescriptor
## - start(config: ModeRunConfig) -> ModeRunFragment
## - tick(frame: ModeTickFrame) -> Array
## - is_complete() -> bool
## - stop(reason: String = "") -> ModeRunFragment

func get_descriptor() -> ModeDescriptor:
	return ModeDescriptor.new()

func start(_config: ModeRunConfig) -> ModeRunFragment:
	return ModeRunFragment.new()

func tick(_frame: ModeTickFrame) -> Array:
	return []

func is_complete() -> bool:
	return false

func stop(_reason: String = "") -> ModeRunFragment:
	return ModeRunFragment.new()
