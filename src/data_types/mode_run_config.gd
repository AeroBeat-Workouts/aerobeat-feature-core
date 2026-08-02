class_name ModeRunConfig
extends RefCounted
## Mode-local setup data derived by a runner or mode-local fixture.

var mode_id := ""
var chart_id := ""
var chart_ref: Dictionary = {}
var chart_data: Dictionary = {}
var seed := 0
var tuning: Dictionary = {}
var scoring: Dictionary = {}
var metadata: Dictionary = {}

func _init(values: Dictionary = {}) -> void:
	mode_id = String(values.get("mode_id", mode_id)).strip_edges()
	chart_id = String(values.get("chart_id", chart_id)).strip_edges()
	chart_ref = _dictionary_or_empty(values.get("chart_ref", chart_ref))
	chart_data = _dictionary_or_empty(values.get("chart_data", chart_data))
	seed = int(values.get("seed", seed))
	tuning = _dictionary_or_empty(values.get("tuning", tuning))
	scoring = _dictionary_or_empty(values.get("scoring", scoring))
	metadata = _dictionary_or_empty(values.get("metadata", metadata))

func duplicate_config() -> ModeRunConfig:
	return get_script().new(to_dict())

func is_valid() -> bool:
	return not mode_id.is_empty()

func to_dict() -> Dictionary:
	return {
		"mode_id": mode_id,
		"chart_id": chart_id,
		"chart_ref": chart_ref.duplicate(true),
		"chart_data": chart_data.duplicate(true),
		"seed": seed,
		"tuning": tuning.duplicate(true),
		"scoring": scoring.duplicate(true),
		"metadata": metadata.duplicate(true)
	}

static func _dictionary_or_empty(value: Variant) -> Dictionary:
	return value.duplicate(true) if value is Dictionary else {}
