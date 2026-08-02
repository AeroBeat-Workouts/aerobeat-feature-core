class_name ModeJudgementEvent
extends "mode_event.gd"
## Mode-produced hit/miss timing judgement fragment.

const RESULT_PERFECT := "perfect"
const RESULT_GOOD := "good"
const RESULT_HIT := "hit"
const RESULT_EARLY := "early"
const RESULT_LATE := "late"
const RESULT_MISS := "miss"

var judgement := ""
var timing_offset_sec := 0.0
var accuracy := 0.0

func _init(values: Dictionary = {}) -> void:
	super(values)
	event_type = TYPE_JUDGEMENT
	judgement = String(values.get("judgement", judgement)).strip_edges()
	timing_offset_sec = float(values.get("timing_offset_sec", timing_offset_sec))
	accuracy = float(values.get("accuracy", accuracy))

func duplicate_judgement() -> ModeJudgementEvent:
	return get_script().new(to_dict())

func is_valid() -> bool:
	return super.is_valid() and not judgement.is_empty()

func to_dict() -> Dictionary:
	var result := super.to_dict()
	result["judgement"] = judgement
	result["timing_offset_sec"] = timing_offset_sec
	result["accuracy"] = accuracy
	return result
