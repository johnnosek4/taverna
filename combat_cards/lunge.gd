class_name Lunge
extends CombatCard


const NAME = "Lunge"
const DESC = "Add 1.5x the Attack of the prior card, or 5 Attack; enter Vulnerable"


func _init() -> void:
	_base_attack = 5
	_base_fate_cost = 0.1


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_attack(hand: Array[CombatCard]) -> int:
	return _base_attack


func get_defense(hand: Array[CombatCard]) -> int:
	return _base_defense
	

func get_attack_mult(hand: Array[CombatCard]) -> float:
	return _base_attack_mult


func get_defense_mult(hand: Array[CombatCard]) -> float:
	return _base_defense_mult
	

func get_fate_cost(hand: Array[CombatCard]) -> float:
	return _base_fate_cost


func get_copy() -> CombatCard:
	print('WARNING: NOT IMPLEMENTED')
	return CombatCard.new()


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	pass
