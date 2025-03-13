class_name PockedSmithy
extends CombatCard


const NAME = "Pocked Smithy"
const DESC = "..."


func _init() -> void:
	_base_power = 0
	_base_toughness = 1
	_base_abilities = [Parasite.new(), Armorer.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> PockedSmithy:
	return PockedSmithy.new()
