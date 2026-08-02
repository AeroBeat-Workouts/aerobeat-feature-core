extends "res://addons/aerobeat-vendor-godot-unit-test/test.gd"

const ModeDescriptorScript := preload("res://addons/aerobeat-mode-core/src/data_types/mode_descriptor.gd")
const ModeRunConfigScript := preload("res://addons/aerobeat-mode-core/src/data_types/mode_run_config.gd")
const ModeTickFrameScript := preload("res://addons/aerobeat-mode-core/src/data_types/mode_tick_frame.gd")
const ModeEventScript := preload("res://addons/aerobeat-mode-core/src/data_types/mode_event.gd")
const ModeJudgementEventScript := preload("res://addons/aerobeat-mode-core/src/data_types/mode_judgement_event.gd")
const ModeScoreDeltaScript := preload("res://addons/aerobeat-mode-core/src/data_types/mode_score_delta.gd")
const ModeRunFragmentScript := preload("res://addons/aerobeat-mode-core/src/data_types/mode_run_fragment.gd")
const ModeFixtureCaseScript := preload("res://addons/aerobeat-mode-core/src/data_types/mode_fixture_case.gd")
const ModeRunnerScript := preload("res://addons/aerobeat-mode-core/src/interfaces/mode_runner.gd")

class ContractModeRunner:
	extends ModeRunner

	var started := false
	var stopped_reason := ""
	var tick_count := 0

	func get_descriptor() -> ModeDescriptor:
		return ModeDescriptorScript.new({
			"mode_id": "contract_boxing",
			"display_name": "Contract Boxing",
			"supported_chart_contracts": ["aerobeat.chart.boxing.v1"],
			"supported_input_contracts": ["aerobeat.input.boxing.v1"]
		})

	func start(config: ModeRunConfig) -> ModeRunFragment:
		started = config != null and config.is_valid()
		return ModeRunFragmentScript.new({
			"fragment_type": ModeRunFragmentScript.TYPE_STARTED,
			"mode_id": config.mode_id
		})

	func tick(frame: ModeTickFrame) -> Array:
		tick_count += 1
		var target_ref := {"id": frame.chart_events[0].get("id", "")} if not frame.chart_events.is_empty() else {}
		var judgement := ModeJudgementEventScript.new({
			"mode_id": "contract_boxing",
			"target_ref": target_ref,
			"position_sec": frame.position_sec,
			"judgement": ModeJudgementEventScript.RESULT_HIT,
			"timing_offset_sec": 0.025,
			"accuracy": 0.95
		})
		var score := ModeScoreDeltaScript.new({
			"mode_id": "contract_boxing",
			"target_ref": target_ref,
			"position_sec": frame.position_sec,
			"score_delta": 100,
			"combo_delta": 1,
			"accuracy_delta": 0.95,
			"judgement": judgement.judgement
		})
		return [judgement, score]

	func is_complete() -> bool:
		return tick_count >= 1

	func stop(reason: String = "") -> ModeRunFragment:
		stopped_reason = reason
		return ModeRunFragmentScript.new({
			"fragment_type": ModeRunFragmentScript.TYPE_STOPPED,
			"mode_id": "contract_boxing",
			"reason": reason
		})

func test_descriptor_advertises_portable_mode_identity_and_contracts() -> void:
	var descriptor := ModeDescriptorScript.new({
		"mode_id": "boxing",
		"display_name": "Boxing",
		"display_key": "mode.boxing",
		"supported_chart_contracts": ["aerobeat.chart.boxing.v1", ""],
		"supported_input_contracts": ["aerobeat.input.boxing.v1"],
		"metadata": {"difficulty": "fixture"}
	})

	assert_true(descriptor.is_valid())
	assert_eq(descriptor.mode_contract_version, "aerobeat.mode.v1")
	assert_eq(descriptor.supported_chart_contracts, ["aerobeat.chart.boxing.v1"])
	assert_eq(descriptor.to_dict()["metadata"]["difficulty"], "fixture")

func test_config_tick_frame_and_fragments_are_deep_copied_mode_local_data() -> void:
	var config := ModeRunConfigScript.new({
		"mode_id": "flow",
		"chart_id": "tiny_chart",
		"chart_ref": {"package_id": "tiny_package"},
		"chart_data": {"objects": [{"id": "note_1"}]},
		"tuning": {"hit_window_sec": 0.12},
		"scoring": {"base_hit": 100}
	})
	var frame := ModeTickFrameScript.new({
		"position_sec": 1.25,
		"delta_sec": 0.016,
		"chart_events": [{"id": "note_1", "lane": "left"}],
		"input_events": [{"event": "left_wrist_cell_entered", "cell": 4, "direction": 3}]
	})
	var fragment := ModeRunFragmentScript.new({
		"fragment_type": ModeRunFragmentScript.TYPE_COMPLETED,
		"mode_id": config.mode_id,
		"summary": {"judgements": 1}
	})

	var config_dict := config.to_dict()
	config_dict["chart_data"]["objects"][0]["id"] = "mutated"

	assert_true(config.is_valid())
	assert_eq(config.chart_data["objects"][0]["id"], "note_1")
	assert_eq(frame.to_dict()["input_events"][0]["event"], "left_wrist_cell_entered")
	assert_true(fragment.is_terminal())

func test_judgement_and_score_delta_are_mode_produced_fragments() -> void:
	var target_ref := {"id": "target_01", "contract": "aerobeat.chart.boxing.v1"}
	var judgement := ModeJudgementEventScript.new({
		"mode_id": "boxing",
		"target_ref": target_ref,
		"position_sec": 2.0,
		"judgement": ModeJudgementEventScript.RESULT_PERFECT,
		"timing_offset_sec": -0.01,
		"accuracy": 1.0
	})
	var score := ModeScoreDeltaScript.new({
		"mode_id": "boxing",
		"target_ref": target_ref,
		"position_sec": 2.0,
		"score_delta": 115,
		"combo_delta": 1,
		"accuracy_delta": 1.0,
		"judgement": judgement.judgement
	})

	assert_true(judgement.is_valid())
	assert_eq(judgement.event_type, ModeEventScript.TYPE_JUDGEMENT)
	assert_eq(judgement.to_dict()["target_ref"]["id"], "target_01")
	assert_eq(score.to_event().event_type, ModeEventScript.TYPE_SCORE_DELTA)
	assert_eq(score.to_dict()["score_delta"], 115)

func test_fixture_case_carries_only_mode_contract_inputs_and_expectations() -> void:
	var fixture := ModeFixtureCaseScript.new({
		"fixture_id": "boxing_one_hit",
		"description": "One target and one matching input event",
		"config": {
			"mode_id": "boxing",
			"chart_id": "tiny_boxing"
		},
		"tick_frames": [
			{
				"position_sec": 0.5,
				"chart_events": [{"id": "target_01", "event": "straight_left"}],
				"input_events": [{"contract": "aerobeat.input.boxing.v1", "event": "straight_left"}]
			}
		],
		"expected_judgements": [{"target_id": "target_01", "judgement": "hit"}],
		"expected_score_deltas": [{"target_id": "target_01", "score_delta": 100}]
	})

	assert_true(fixture.is_valid())
	assert_eq(fixture.tick_frames.size(), 1)
	assert_false(fixture.to_dict().has("session_id"))
	assert_false(fixture.to_dict().has("clock"))
	assert_false(fixture.to_dict().has("transport"))

func test_mode_runner_lifecycle_uses_mode_config_tick_frame_and_fragments() -> void:
	var runner := ContractModeRunner.new()
	var descriptor := runner.get_descriptor()
	var config := ModeRunConfigScript.new({"mode_id": descriptor.mode_id, "chart_id": "tiny"})
	var start_fragment := runner.start(config)
	var frame := ModeTickFrameScript.new({
		"position_sec": 1.0,
		"delta_sec": 0.016,
		"chart_events": [{"id": "target_01"}],
		"input_events": [{"event": "straight_left"}]
	})
	var emitted := runner.tick(frame)
	var stop_fragment := runner.stop("contract_test")

	assert_true(runner.started)
	assert_true(descriptor.is_valid())
	assert_eq(start_fragment.fragment_type, ModeRunFragmentScript.TYPE_STARTED)
	assert_eq(emitted.size(), 2)
	assert_true(emitted[0] is ModeJudgementEvent)
	assert_true(emitted[1] is ModeScoreDelta)
	assert_true(runner.is_complete())
	assert_eq(stop_fragment.reason, "contract_test")
