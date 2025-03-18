class_name ChainsOfMalice
extends CombatCard


const NAME = "Chains of Malice"
const DESC = "..."


func _init() -> void:
	_base_power = 3
	_base_toughness = 1
	_base_abilities = [Venom.new(), Brittle.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> ChainsOfMalice:
	return ChainsOfMalice.new()
