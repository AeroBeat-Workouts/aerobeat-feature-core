class_name ModeDescriptor
extends RefCounted
## Portable identity and capability contract for an AeroBeat gameplay mode.

const CONTRACT_VERSION := "aerobeat.mode.v1"

var mode_id := ""
var display_name := ""
var display_key := ""
var supported_chart_contracts: Array[String] = []
var supported_input_contracts: Array[String] = []
var mode_contract_version := CONTRACT_VERSION
var metadata: Dictionary = {}

func _init(values: Dictionary = {}) -> void:
	mode_id = String(values.get("mode_id", mode_id)).strip_edges()
	display_name = String(values.get("display_name", display_name)).strip_edges()
	display_key = String(values.get("display_key", display_key)).strip_edges()
	supported_chart_contracts = _string_array(values.get("supported_chart_contracts", supported_chart_contracts))
	supported_input_contracts = _string_array(values.get("supported_input_contracts", supported_input_contracts))
	mode_contract_version = String(values.get("mode_contract_version", mode_contract_version)).strip_edges()
	metadata = _dictionary_or_empty(values.get("metadata", metadata))

func duplicate_descriptor() -> ModeDescriptor:
	return get_script().new(to_dict())

func is_valid() -> bool:
	return not mode_id.is_empty() and not mode_contract_version.is_empty()

func to_dict() -> Dictionary:
	return {
		"mode_id": mode_id,
		"display_name": display_name,
		"display_key": display_key,
		"supported_chart_contracts": supported_chart_contracts.duplicate(),
		"supported_input_contracts": supported_input_contracts.duplicate(),
		"mode_contract_version": mode_contract_version,
		"metadata": metadata.duplicate(true)
	}

static func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if value is Array:
		for item in value:
			var normalized := String(item).strip_edges()
			if not normalized.is_empty():
				result.append(normalized)
	return result

static func _dictionary_or_empty(value: Variant) -> Dictionary:
	return value.duplicate(true) if value is Dictionary else {}
