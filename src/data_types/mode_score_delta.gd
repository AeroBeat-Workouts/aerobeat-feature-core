class_name ModeScoreDelta
extends RefCounted
## Mode-produced scoring unit for runner-owned aggregation.

var mode_id := ""
var target_ref: Dictionary = {}
var position_sec := 0.0
var score_delta := 0
var combo_delta := 0
var accuracy_delta := 0.0
var judgement := ""
var metadata: Dictionary = {}

func _init(values: Dictionary = {}) -> void:
	mode_id = String(values.get("mode_id", mode_id)).strip_edges()
	target_ref = _dictionary_or_empty(values.get("target_ref", target_ref))
	position_sec = float(values.get("position_sec", position_sec))
	score_delta = int(values.get("score_delta", values.get("score", score_delta)))
	combo_delta = int(values.get("combo_delta", combo_delta))
	accuracy_delta = float(values.get("accuracy_delta", accuracy_delta))
	judgement = String(values.get("judgement", judgement)).strip_edges()
	metadata = _dictionary_or_empty(values.get("metadata", metadata))

func duplicate_delta() -> ModeScoreDelta:
	return get_script().new(to_dict())

func to_event() -> ModeEvent:
	return ModeEvent.new({
		"event_type": ModeEvent.TYPE_SCORE_DELTA,
		"mode_id": mode_id,
		"target_ref": target_ref,
		"position_sec": position_sec,
		"metadata": to_dict()
	})

func to_dict() -> Dictionary:
	return {
		"mode_id": mode_id,
		"target_ref": target_ref.duplicate(true),
		"position_sec": position_sec,
		"score_delta": score_delta,
		"combo_delta": combo_delta,
		"accuracy_delta": accuracy_delta,
		"judgement": judgement,
		"metadata": metadata.duplicate(true)
	}

static func _dictionary_or_empty(value: Variant) -> Dictionary:
	return value.duplicate(true) if value is Dictionary else {}
