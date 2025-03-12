class_name TemplateCombatCard
extends CombatCard


const NAME = "NOT IMPLEMENTED"
const DESC = "..."


func _init() -> void:
	_base_power = 1
	_base_toughness = 1
	_base_abilities = [Feed.new(), Absorb.new(), Endure.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Feaster:
	return Feaster.new()
