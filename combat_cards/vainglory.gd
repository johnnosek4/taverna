class_name Vainglory
extends CombatCard


const NAME = "Vainglory"
const DESC = "Add 10 attack; subtract 2 attack per every other card in hand"

var card_penalty: int = 2

func _init() -> void:
	_base_attack = 10
	_base_fate_cost = 0.1


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_attack(hand: Array[CombatCard]) -> int:
	return max(_base_attack - ((len(hand) - 1) * 2),0)


func get_copy() -> Vainglory:
	return Vainglory.new()
