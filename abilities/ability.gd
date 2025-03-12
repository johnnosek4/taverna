class_name Ability
extends RefCounted

const PROCESS_TIME: float = 2.2


func get_name() -> String:
	return 'not implemented'

	
func get_description() -> String:
	return 'not implemented'


func modify_power(power: int) -> int:
	return power
	
	
func modify_toughness(toughness: int) -> int:
	return toughness


func on_knock(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	pass


func on_draw(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	pass
	
	
func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	pass
	
	
func on_action_fails(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	pass
	
	
func on_attack_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	pass
	

func on_defend_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	pass
	

func on_destroy(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> bool:
	return true


func on_discard(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> bool:
	return true
