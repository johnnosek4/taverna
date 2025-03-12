class_name WandOfAffliction
extends CombatCard


const NAME = "Wand of Affliction"
const DESC = "..."


func _init() -> void:
	_base_power = 5
	_base_toughness = 1
	_base_abilities = [Curse.new(), Infest.new(), Parasite.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> WandOfAffliction:
	return WandOfAffliction.new()
