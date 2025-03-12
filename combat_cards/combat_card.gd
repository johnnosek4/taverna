class_name CombatCard
extends Resource

'''
DEV NOTES 2.0
potentially add getters for power and toughness, that check
abilities to see if they modify power and toughness.  e.g.

Cunning: 
When this card is in hand, it gets +1 Temporary Power for every other card in hand. 
Temporary power is lost after battle. 

so how would we reflect that here:
	>the instance of the cunning ability could have an _on_draw
	method that tracks the hand_size and updates an internal variable
	>it would also have a 'modifies power' function that is called by the
	card getter for power, thus returning an updated value,
	>it might then have a series of, 'on discard' or 'on_action_end'
	in order to reset that internal variable
	
NOTE: do we need to clear base abilites between combats? i don't think so, since
the deck from the player gets copied over to the deck of the combat stats, which should
create new instances of base abilities
'''

const DISCARD_TIME = 0.2
const DESTROY_TIME = 0.2

var _base_power: int
var _base_toughness: int
var _base_abilities: Array[Ability] #of abilities (basically arbirtrary code)
var _additional_abilities: Array[Ability] = [] #these are granted during the course of combat
var _all_abilities: Array[Ability] #set this in init and when adding additial abilities


func _init() -> void:
	_all_abilities = _base_abilities.duplicate()


func get_card_name() -> String:
	return "not implemented"


func get_card_description() -> String:
	return "not implemented"


func get_power() -> int:
	var power = _base_power
	for ability in _all_abilities:
		power = ability.modify_power(power)
	return power


func get_toughness() -> int:
	var toughness = _base_toughness
	for ability in _all_abilities:
		toughness = ability.modify_toughness(toughness)
	return toughness


func get_abilities() -> Array[Ability]:
	return _all_abilities


func add_ability(ability: Ability) -> void:
	_additional_abilities.append(ability)
	_all_abilities = _base_abilities + _additional_abilities


func remove_ability(ability: Ability) -> void:
	var base_abilities_dupe = _base_abilities.duplicate()
	for base_ability in base_abilities_dupe:
		if is_instance_of(ability, base_ability.get_class()):
			_base_abilities.erase(base_ability)
	var additional_abilities_dupe = _additional_abilities.duplicate()
	for additional_ability in additional_abilities_dupe:
		if is_instance_of(ability, additional_ability.get_class()):
			_additional_abilities.erase(additional_ability)
		
	#_base_abilities.erase(ability) <not sure this method will work, since each ability is its own object with a uniqui pointer, so even if its a new object of the same type it wouldnt be erase i dont think
	#_additional_abilities.erase(ability)
	_all_abilities = _base_abilities + _additional_abilities


func clear_added_abilities() -> void:
	_additional_abilities = []
	_all_abilities = _base_abilities + _additional_abilities


func has_ability(ability: Ability) -> bool:
	if get_abilities().has(ability):
		return true
	return false


func has_ability_by_name(name: String) -> bool:
	for ability in get_abilities():
		if ability.get_name() == name:
			return true
	return false


func get_copy() -> CombatCard:
	print('WARNING: NOT IMPLEMENTED')
	return CombatCard.new()
	
	
func on_knock(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	for ability in _all_abilities:
		await ability.on_knock(self, cur_controller, opp_controller)


func on_draw(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	for ability in _all_abilities:
		await ability.on_draw(self, cur_controller, opp_controller)


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	for ability in _all_abilities:
		await ability.on_action_succedes(self, cur_controller, opp_controller)


func on_action_fails(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	for ability in _all_abilities:
		await ability.on_action_fails(self, cur_controller, opp_controller)


func on_attack_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	for ability in _all_abilities:
		await ability.on_attack_succedes(self, cur_controller, opp_controller)


func on_defend_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	for ability in _all_abilities:
		await ability.on_defend_succedes(self, cur_controller, opp_controller)


func on_destroy(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	var default: bool = true
	for ability in _all_abilities:
		var default_from_ability = await ability.on_destroy(self, cur_controller, opp_controller)
		default = default and default_from_ability
	if default:
		cur_controller.combat_cards.move_card(
			self, 
			CombatCardState.CardTarget.HAND,
			CombatCardState.CardTarget.GRAVEYARD)
		await cur_controller.get_tree().create_timer(DESTROY_TIME).timeout


func on_discard(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	var default: bool = true
	for ability in _all_abilities:
		var default_from_ability = await ability.on_discard(self, cur_controller, opp_controller)
		default = default and default_from_ability
	if default:
		cur_controller.combat_cards.move_card(
			self, 
			CombatCardState.CardTarget.HAND,
			CombatCardState.CardTarget.DISCARD)
		await cur_controller.get_tree().create_timer(DISCARD_TIME).timeout

	
	
# This is one proposed way of doing it, where destruction still happens at the top level
# Default behavior is return true, but some on_destroy effects may return false
#func on_destroy(cur_controller: PlayerController, opp_controller: PlayerController) -> bool:
	#var destroy: bool = true
	#for ability in _all_abilities:
		#var destroy_from_ability = await ability.on_destroy(self, cur_controller, opp_controller)
		#destroy = destroy and destroy_from_ability
	#return destroy
