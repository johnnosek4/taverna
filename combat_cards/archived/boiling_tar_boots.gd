class_name BoilingTarBoots
extends CombatCard


const NAME = "Boiling Tar Boots"
const DESC = "..."


func _init() -> void:
	_base_power = 1
	_base_toughness = 4
	_base_abilities = [Parasite.new(), Grow.new(), Absorb.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> BoilingTarBoots:
	return BoilingTarBoots.new()
