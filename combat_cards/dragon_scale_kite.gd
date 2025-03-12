class_name DragonScaleKite
extends CombatCard


const NAME = "Dragon Scale Kite"
const DESC = "..."


func _init() -> void:
	_base_power = 0
	_base_toughness = 7
	_base_abilities = [Armor.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> DragonScaleKite:
	return DragonScaleKite.new()
