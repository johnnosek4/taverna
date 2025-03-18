class_name TemplateCombatCard
extends CombatCard


const NAME = "NOT IMPLEMENTED"
const DESC = "..."


func _init() -> void:
	_base_attack = 0
	_base_defense = 0
	_base_attack_mult = 1.0
	_base_defense_mult = 1.0
	_base_fate_cost = 0.1


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_attack() -> int:
	return _base_attack


func get_defense() -> int:
	return _base_defense
	

func get_attack_mult() -> float:
	return _base_attack_mult


func get_defense_mult() -> float:
	return _base_defense_mult
	

func get_fate_cost() -> float:
	return _base_fate_cost


func get_copy() -> CombatCard:
	print('WARNING: NOT IMPLEMENTED')
	return CombatCard.new()


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	pass
