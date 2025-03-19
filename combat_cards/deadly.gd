class_name Deadly
extends CombatCard


const NAME = "Deadly"
const DESC = "Add 50% Attack Mult"


func _init() -> void:
	_base_attack_mult = 0.5
	_base_fate_cost = 0.1


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Deadly:
	return Deadly.new()
