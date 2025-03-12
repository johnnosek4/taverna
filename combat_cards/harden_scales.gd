class_name HardenScales
extends CombatCard


const NAME = "Harden Scales"
const DESC = "..."


func _init() -> void:
	_base_power = 0
	_base_toughness = 2
	_base_abilities = [Heal.new(), Armor.new(), Swarm.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> HardenScales:
	return HardenScales.new()
