class_name Block
extends CombatCard


const NAME = "Block"
const DESC = "Add 5 Defense"


func _init() -> void:
	_id = "002"
	_base_defense = 5
	_base_fate_cost = 0.1
	_card_type = Type.DEFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Block:
	return Block.new()
