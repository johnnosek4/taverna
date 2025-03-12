class_name WormFetish
extends CombatCard


const NAME = "Worm Fetish"
const DESC = "..."


func _init() -> void:
	_base_power = 1
	_base_toughness = 1
	_base_abilities = [Infest.new(), Burgeon.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> WormFetish:
	return WormFetish.new()
