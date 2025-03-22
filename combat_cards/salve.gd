class_name Salve
extends CombatCard


const NAME = "Salve"
const DESC = "Heal 5 HP"

var hp_boost: int = 5


func _init() -> void:
	_id = "022"
	_base_fate_cost = 0.1
	_card_type = Type.DEFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Salve:
	return Salve.new()


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	cur_controller.stats.boost_hp(hp_boost)
