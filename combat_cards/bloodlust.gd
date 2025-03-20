class_name Bloodlust
extends CombatCard


const NAME = "Bloodlust"
const DESC = "Add 2 Attack per Offensive card in Hand"

var attack_boost_per_card: int = 2


func _init() -> void:
	_base_fate_cost = 0.1
	_card_type = Type.OFFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_attack(hand: Array[CombatCard]) -> int:
	var _attack: int = 0
	for card in hand:
		if card.get_card_type() == Type.OFFENSIVE:
			_attack += attack_boost_per_card
	return _attack


func get_copy() -> Bloodlust:
	return Bloodlust.new()
