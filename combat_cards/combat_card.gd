class_name CombatCard
extends RefCounted

enum Type {
	OFFENSIVE,
	DEFENSIVE,
	CHAOTIC,
}

'''
'''

const DISCARD_TIME = 0.2
const DESTROY_TIME = 0.2

var _id: String
var _base_attack: int = 0
var _base_defense: int = 0
var _base_attack_mult: float = 0.0
var _base_defense_mult: float = 0.0
var _base_fate_cost: float = 0.1
var _card_type: Type
#var _base_abilities: Array[Ability] #of abilities (basically arbirtrary code)
#var _additional_abilities: Array[Ability] = [] #these are granted during the course of combat
#var _all_abilities: Array[Ability] #set this in init and when adding additial abilities
var combat_ui_manager: CombatUIManager


#func _init() -> void:
	#_all_abilities = _base_abilities.duplicate()

func get_id() -> String:
	return _id


func get_card_name() -> String:
	return "not implemented"


func get_card_description() -> String:
	return "not implemented"
	

func get_card_type() -> Type:
	return _card_type


func get_attack(hand: Array[CombatCard]) -> int:
	return _base_attack


func get_defense(hand: Array[CombatCard]) -> int:
	return _base_defense
	

func get_attack_mult(hand: Array[CombatCard]) -> float:
	return _base_attack_mult


func get_defense_mult(hand: Array[CombatCard]) -> float:
	return _base_defense_mult
	

func get_fate_cost() -> float:
	return _base_fate_cost


func get_copy() -> CombatCard:
	print('WARNING: get_copy() NOT IMPLEMENTED ON CARD ' + get_card_name())
	return CombatCard.new()
	
	
func on_knock(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	pass


func on_draw(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	pass


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	pass


func on_action_fails(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	pass


#func on_attack_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	#pass
#
#
#func on_defend_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	#pass


func on_destroy(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	cur_controller.combat_cards.move_card(
		self, 
		CombatCardState.CardTarget.HAND,
		CombatCardState.CardTarget.GRAVEYARD)
	await cur_controller.get_tree().create_timer(DESTROY_TIME).timeout


func on_discard(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	cur_controller.combat_cards.move_card(
		self, 
		CombatCardState.CardTarget.HAND,
		CombatCardState.CardTarget.DISCARD)
	await cur_controller.get_tree().create_timer(DISCARD_TIME).timeout
