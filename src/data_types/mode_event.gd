class_name ModeEvent
extends RefCounted
## Shared base event emitted by a mode rule engine.

const TYPE_STARTED := "started"
const TYPE_COMPLETED := "completed"
const TYPE_STOPPED := "stopped"
const TYPE_JUDGEMENT := "judgement"
const TYPE_SCORE_DELTA := "score_delta"
const TYPE_NOTE := "note"

var event_type := ""
var mode_id := ""
var target_ref: Dictionary = {}
var position_sec := 0.0
var metadata: Dictionary = {}

func _init(values: Dictionary = {}) -> void:
	event_type = String(values.get("event_type", values.get("type", event_type))).strip_edges()
	mode_id = String(values.get("mode_id", mode_id)).strip_edges()
	target_ref = _dictionary_or_empty(values.get("target_ref", target_ref))
	position_sec = float(values.get("position_sec", position_sec))
	metadata = _dictionary_or_empty(values.get("metadata", metadata))

func duplicate_event() -> ModeEvent:
	return get_script().new(to_dict())

func is_valid() -> bool:
	return not event_type.is_empty() and not mode_id.is_empty()

func to_dict() -> Dictionary:
	return {
		"event_type": event_type,
		"mode_id": mode_id,
		"target_ref": target_ref.duplicate(true),
		"position_sec": position_sec,
		"metadata": metadata.duplicate(true)
	}

static func _dictionary_or_empty(value: Variant) -> Dictionary:
	return value.duplicate(true) if value is Dictionary else {}
