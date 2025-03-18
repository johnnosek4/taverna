class_name KillerInstinct
extends CombatCard


const NAME = "Killer Instinct"
const DESC = "..."


func _init() -> void:
	_base_power = 1
	_base_toughness = 0
	_base_abilities = [Endure.new(), Burgeon.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> KillerInstinct:
	return KillerInstinct.new()
