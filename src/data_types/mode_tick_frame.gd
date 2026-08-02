class_name ModeTickFrame
extends RefCounted
## One portable rule-engine tick worth of timeline, chart, and normalized input data.

var position_sec := 0.0
var delta_sec := 0.0
var chart_events: Array[Dictionary] = []
var input_events: Array[Dictionary] = []
var metadata: Dictionary = {}

func _init(values: Dictionary = {}) -> void:
	position_sec = float(values.get("position_sec", position_sec))
	delta_sec = float(values.get("delta_sec", delta_sec))
	chart_events = _dictionary_array(values.get("chart_events", chart_events))
	input_events = _dictionary_array(values.get("input_events", input_events))
	metadata = _dictionary_or_empty(values.get("metadata", metadata))

func duplicate_frame() -> ModeTickFrame:
	return get_script().new(to_dict())

func to_dict() -> Dictionary:
	return {
		"position_sec": position_sec,
		"delta_sec": delta_sec,
		"chart_events": chart_events.duplicate(true),
		"input_events": input_events.duplicate(true),
		"metadata": metadata.duplicate(true)
	}

static func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result

static func _dictionary_or_empty(value: Variant) -> Dictionary:
	return value.duplicate(true) if value is Dictionary else {}
