class_name DeathRay
extends CombatCard


const NAME = "Death Ray"
const DESC = "..."


func _init() -> void:
	_base_power = 9
	_base_toughness = 1
	_base_abilities = [Doom.new(), Frail.new(), Fateless.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> DeathRay:
	return DeathRay.new()
