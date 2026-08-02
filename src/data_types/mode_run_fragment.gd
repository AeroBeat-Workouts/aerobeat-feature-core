class_name ModeRunFragment
extends RefCounted
## Start, stop, completion, or summary fragment produced by a mode runner.

const TYPE_STARTED := "started"
const TYPE_COMPLETED := "completed"
const TYPE_STOPPED := "stopped"
const TYPE_SUMMARY := "summary"

var fragment_type := ""
var mode_id := ""
var reason := ""
var events: Array = []
var judgements: Array = []
var score_deltas: Array = []
var summary: Dictionary = {}
var metadata: Dictionary = {}

func _init(values: Dictionary = {}) -> void:
	fragment_type = String(values.get("fragment_type", values.get("type", fragment_type))).strip_edges()
	mode_id = String(values.get("mode_id", mode_id)).strip_edges()
	reason = String(values.get("reason", reason)).strip_edges()
	events = _array_copy(values.get("events", events))
	judgements = _array_copy(values.get("judgements", judgements))
	score_deltas = _array_copy(values.get("score_deltas", score_deltas))
	summary = _dictionary_or_empty(values.get("summary", summary))
	metadata = _dictionary_or_empty(values.get("metadata", metadata))

func duplicate_fragment() -> ModeRunFragment:
	return get_script().new(to_dict())

func is_terminal() -> bool:
	return fragment_type == TYPE_COMPLETED or fragment_type == TYPE_STOPPED

func to_dict() -> Dictionary:
	return {
		"fragment_type": fragment_type,
		"mode_id": mode_id,
		"reason": reason,
		"events": _serialize_array(events),
		"judgements": _serialize_array(judgements),
		"score_deltas": _serialize_array(score_deltas),
		"summary": summary.duplicate(true),
		"metadata": metadata.duplicate(true)
	}

static func _array_copy(value: Variant) -> Array:
	return value.duplicate(true) if value is Array else []

static func _serialize_array(value: Array) -> Array:
	var result := []
	for item in value:
		if item is RefCounted and item.has_method("to_dict"):
			result.append(item.to_dict())
		elif item is Dictionary:
			result.append(item.duplicate(true))
		else:
			result.append(item)
	return result

static func _dictionary_or_empty(value: Variant) -> Dictionary:
	return value.duplicate(true) if value is Dictionary else {}
