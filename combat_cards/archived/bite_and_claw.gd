class_name BiteAndClaw
extends CombatCard


const NAME = "Bite and Claw"
const DESC = "..."


func _init() -> void:
	_base_power = 3
	_base_toughness = 0
	_base_abilities = [Bloodlust.new(), Feed.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> BiteAndClaw:
	return BiteAndClaw.new()
