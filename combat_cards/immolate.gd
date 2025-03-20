class_name Immolate
extends CombatCard


const NAME = "Immolate"
const DESC = "Add 3 Attack per card in Hand; Destroy all cards in Hand at end of turn"

var _attack_per_card


func _init() -> void:
	_base_fate_cost = 0.1
	_card_type = Type.OFFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_attack(hand: Array[CombatCard]) -> int:
	return len(hand) * _attack_per_card


func get_copy() -> Immolate:
	return Immolate.new()


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	#needs to set some sort of property on cards so that on_discard they instead call on_destroy
	pass
