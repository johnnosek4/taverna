class_name GlacierStone
extends CombatCard


const NAME = "Glacier Stone"
const DESC = "..."


func _init() -> void:
	_base_power = 0
	_base_toughness = 3
	_base_abilities = [Petrify.new(), Forge.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> GlacierStone:
	return GlacierStone.new()
