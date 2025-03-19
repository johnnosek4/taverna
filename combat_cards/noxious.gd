class_name Noxious
extends CombatCard


const NAME = "Noxious"
const DESC = "Add 2 Attack per card in Hand; Take 1 dmg per card in Hand"

var attack_per_card: int = 2
var dmg_per_card: int = 1


func _init() -> void:
	_base_fate_cost = 0.1


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC
	
	
func get_attack(hand: Array[CombatCard]) -> int:
	return len(hand) * attack_per_card


func get_copy() -> Noxious:
	return Noxious.new()


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	cur_controller.stats.apply_damage(dmg_per_card * len(cur_controller.combat_cards.hand))
