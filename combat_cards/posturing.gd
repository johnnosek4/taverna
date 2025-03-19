class_name Posturing
extends CombatCard


const NAME = "Posturing"
const DESC = "This card has no effect"


func _init() -> void:
	_base_fate_cost = 0.0


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Posturing:
	return Posturing.new()


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	pass
