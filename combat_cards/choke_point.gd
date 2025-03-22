class_name ChokePoint
extends CombatCard


const NAME = "Choke Point"
const DESC = "Add 4x Defense Mult; Lose 1x Defense Mult per each additional card in Hand"

var starting_def_mult: float = 4.0
var def_mult_per_card: float = 1.0


func _init() -> void:
	_id = "004"
	_base_fate_cost = 0.1
	_card_type = Type.DEFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_defense_mult(hand: Array[CombatCard]) -> float:
	var defense_mult: float = starting_def_mult
	for card in hand:
		if not card == self:
			defense_mult -= def_mult_per_card
	return defense_mult
	

func get_copy() -> ChokePoint:
	return ChokePoint.new()
