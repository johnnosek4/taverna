class_name Forged
extends CombatCard


const NAME = "Forged"
const DESC = "Add 3 Attack; Every time this card is discarded, add an additional 2 Attack"

var discard_count: int = 0
var attack_per_discard: int = 2


func _init() -> void:
	_base_attack = 3
	_base_fate_cost = 0.1
	_card_type = Type.OFFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC + '(' + str(discard_count) + ')'


func get_attack(hand: Array[CombatCard]) -> int:
	return _base_attack + (discard_count * attack_per_discard)


func get_copy() -> Forged:
	return Forged.new()


func on_discard(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	discard_count += 1
	super.on_discard(cur_controller, opp_controller)
