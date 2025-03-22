class_name Flank
extends CombatCard


const NAME = "Flank"
const DESC = "If there are exactly two Flanks in Hand, Add 4 Attack and 4 Defense"

var _attack = 4
var _defense = 4


func _init() -> void:
	_id = "008"
	_base_fate_cost = 0.1
	_card_type = Type.OFFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_attack(hand: Array[CombatCard]) -> int:
	var flank_count: int = 0
	for card in hand:
		if card.get_card_name() == NAME:
			flank_count += 1
	if not flank_count == 2:
		return _base_attack
	else:
		return _attack


func get_defense(hand: Array[CombatCard]) -> int:
	var flank_count: int = 0
	for card in hand:
		if card.get_card_name() == NAME:
			flank_count += 1
	if not flank_count == 2:
		return _base_defense
	else:
		return _defense


func get_copy() -> Flank:
	return Flank.new()
