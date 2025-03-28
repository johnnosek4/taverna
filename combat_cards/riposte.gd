class_name Riposte
extends CombatCard


const NAME = "Riposte"
const DESC = "Add 3 Defense; Add 2 Attack"


func _init() -> void:
	_id = "021"
	_base_attack = 2
	_base_defense = 3
	_card_type = Type.DEFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Riposte:
	return Riposte.new()
