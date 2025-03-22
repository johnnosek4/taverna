class_name Swarm
extends CombatCard


const NAME = "Swarm"
const DESC = "Add 3 Attack; Add 2 additional Attack from this card for each Swarm in Hand"

var attack_per_swarm: int = 2

func _init() -> void:
	_id = "024"
	_base_attack = 3
	_base_fate_cost = 0.1
	_card_type = Type.OFFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_attack(hand: Array[CombatCard]) -> int:
	var swarm_count: int = 0
	for card in hand:
		if card.get_card_name() == NAME:
			swarm_count += 1
	return _base_attack + (attack_per_swarm * (swarm_count -1))


func get_copy() -> Swarm:
	return Swarm.new()
