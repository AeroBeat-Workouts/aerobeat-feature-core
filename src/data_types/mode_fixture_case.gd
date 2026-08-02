class_name ModeFixtureCase
extends RefCounted
## Tiny portable fixture shape for mode-rule contract tests.

var fixture_id := ""
var description := ""
var config: ModeRunConfig
var tick_frames: Array[ModeTickFrame] = []
var expected_events: Array[Dictionary] = []
var expected_judgements: Array[Dictionary] = []
var expected_score_deltas: Array[Dictionary] = []
var expected_fragments: Array[Dictionary] = []
var metadata: Dictionary = {}

func _init(values: Dictionary = {}) -> void:
	fixture_id = String(values.get("fixture_id", fixture_id)).strip_edges()
	description = String(values.get("description", description)).strip_edges()
	config = _config_from(values.get("config", {}))
	tick_frames = _frame_array(values.get("tick_frames", tick_frames))
	expected_events = _dictionary_array(values.get("expected_events", expected_events))
	expected_judgements = _dictionary_array(values.get("expected_judgements", expected_judgements))
	expected_score_deltas = _dictionary_array(values.get("expected_score_deltas", expected_score_deltas))
	expected_fragments = _dictionary_array(values.get("expected_fragments", expected_fragments))
	metadata = _dictionary_or_empty(values.get("metadata", metadata))

func duplicate_fixture() -> ModeFixtureCase:
	return get_script().new(to_dict())

func is_valid() -> bool:
	return not fixture_id.is_empty() and config != null and config.is_valid()

func to_dict() -> Dictionary:
	return {
		"fixture_id": fixture_id,
		"description": description,
		"config": config.to_dict() if config != null else {},
		"tick_frames": _serialize_frames(tick_frames),
		"expected_events": expected_events.duplicate(true),
		"expected_judgements": expected_judgements.duplicate(true),
		"expected_score_deltas": expected_score_deltas.duplicate(true),
		"expected_fragments": expected_fragments.duplicate(true),
		"metadata": metadata.duplicate(true)
	}

static func _config_from(value: Variant) -> ModeRunConfig:
	if value is ModeRunConfig:
		return value.duplicate_config()
	if value is Dictionary:
		return ModeRunConfig.new(value)
	return ModeRunConfig.new()

static func _frame_array(value: Variant) -> Array[ModeTickFrame]:
	var result: Array[ModeTickFrame] = []
	if value is Array:
		for item in value:
			if item is ModeTickFrame:
				result.append(item.duplicate_frame())
			elif item is Dictionary:
				result.append(ModeTickFrame.new(item))
	return result

static func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result

static func _serialize_frames(value: Array[ModeTickFrame]) -> Array:
	var result := []
	for frame in value:
		result.append(frame.to_dict())
	return result

static func _dictionary_or_empty(value: Variant) -> Dictionary:
	return value.duplicate(true) if value is Dictionary else {}
