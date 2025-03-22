class_name Fortify
extends CombatCard


const NAME = "Fortify"
const DESC = "Add 0.5 Defense Mult for each Defensive Card in Hand"

var defense_mult_per_card: float = 0.5

func _init() -> void:
	_id = "010"
	_base_fate_cost = 0.1
	_card_type = Type.DEFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_defense_mult(hand: Array[CombatCard]) -> float:
	var _defense_mult: float = 0
	for card in hand:
		if card.get_card_type() == Type.DEFENSIVE:
			_defense_mult += defense_mult_per_card
	return _defense_mult


func get_copy() -> Fortify:
	return Fortify.new()
