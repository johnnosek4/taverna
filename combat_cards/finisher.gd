class_name Finisher
extends CombatCard


const NAME = "Finisher"
const DESC = "If this is the last card in your hand, add 1 Attack Mult"

var _attack_mult: float = 1.0


func _init() -> void:
	_base_fate_cost = 0.1


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC
	

func get_attack_mult(hand: Array[CombatCard]) -> float:
	if hand[-1] == self:
		return _attack_mult
	return _base_attack_mult


func get_copy() -> Finisher:
	return Finisher.new()
