class_name Trojka
extends CombatCard


const NAME = "Trojka"
const DESC = "If you have 3 of the same card in Hand, add 2x Attack Mult"

var _attack_mult: float = 2.0
var _count_threshold: int = 3


func _init() -> void:
	_id = "025"
	_base_fate_cost = 0.1
	_card_type = Type.CHAOTIC #Offensive?


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC
	

func get_attack_mult(hand: Array[CombatCard]) -> float:
	var hand_dict = {}
	for card in hand:
		hand_dict[card.get_card_name()] = hand_dict.get_or_add(card.get_card_name(), 0) + 1
	for key in hand_dict:
		if hand_dict[key] >= _count_threshold:
			return _attack_mult
	return _base_attack_mult


func get_copy() -> Trojka:
	return Trojka.new()
