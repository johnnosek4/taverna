class_name TurnToSmoke
extends CombatCard


const NAME = "Turn to Smoke"
const DESC = "..."


func _init() -> void:
	_base_power = 0
	_base_toughness = 1
	_base_abilities = [Endure.new(), Relentless.new(), Swarm.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> TurnToSmoke:
	return TurnToSmoke.new()
