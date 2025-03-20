class_name Turtle
extends CombatCard


const NAME = "Turtle"
const DESC = "Add 10 Defense; Add -1x Attack Mult"


func _init() -> void:
	_base_defense = 10
	_base_attack_mult = -1.
	_base_fate_cost = 0.1
	_card_type = Type.DEFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Turtle:
	return Turtle.new()
