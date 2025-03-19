class_name Riposte
extends CombatCard


const NAME = "Riposte"
const DESC = "Add 3 Defense; Add 2 Attack"


func _init() -> void:
	_base_attack = 3
	_base_defense = 2


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Riposte:
	return Riposte.new()
