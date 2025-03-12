class_name StoneFists
extends CombatCard


const NAME = "Stone Fists"
const DESC = "..."


func _init() -> void:
	_base_power = 2
	_base_toughness = 3
	_base_abilities = [Guard.new(), Bloodlust.new(), Burgeon.new(), Fateless.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> StoneFists:
	return StoneFists.new()
