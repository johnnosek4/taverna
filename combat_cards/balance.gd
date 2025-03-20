class_name Balance
extends CombatCard


const NAME = "Balance"
const DESC = "If there are no successive card types, Add 5 Attack; Add 5 Defense"

var _attack_boost: int = 5
var _defense_boost: int = 5


func _init() -> void:
	_base_fate_cost = 0.1
	_card_type = Type.CHAOTIC


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_attack(hand: Array[CombatCard]) -> int:
	if not _check_successive_card_types(hand):
		return _attack_boost
	return _base_attack


func get_defense(hand: Array[CombatCard]) -> int:
	if not _check_successive_card_types(hand):
		return _defense_boost
	return _base_defense


func get_copy() -> Balance:
	return Balance.new()


func _check_successive_card_types(hand: Array[CombatCard]) -> bool:
	for idx in range(len(hand)-1):
		if hand[idx].get_card_type() == hand[idx+1].get_card_type():
			return true
	return false
