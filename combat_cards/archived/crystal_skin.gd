class_name CrystalSkin
extends CombatCard


const NAME = "Crystal Skin"
const DESC = "..."


func _init() -> void:
	_base_power = 0
	_base_toughness = 7
	_base_abilities = [Relentless.new(), Brittle.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> CrystalSkin:
	return CrystalSkin.new()
