class_name GreaterSalve
extends CombatCard


const NAME = "Greater Salve"
const DESC = "Heal 2 HP per card in Hand"

var hp_boost: int = 2


func _init() -> void:
	_base_fate_cost = 0.1


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> GreaterSalve:
	return GreaterSalve.new()


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	var hand_count = len(cur_controller.combat_cards.deck)
	cur_controller.stats.boost_hp(hp_boost * hand_count)
