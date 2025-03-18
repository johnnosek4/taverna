class_name HeartStringBow
extends CombatCard


const NAME = "Heartstring Bow"
const DESC = "..."


func _init() -> void:
	_base_power = 4
	_base_toughness = 2
	_base_abilities = [Heal.new(), Grow.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> HeartStringBow:
	return HeartStringBow.new()
