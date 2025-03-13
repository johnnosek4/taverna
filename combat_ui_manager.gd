class_name CombatUIManager
extends Node

const PROCESS_TIME : float = 1.0

var p1_ui: PlayerUI
var p2_ui: PlayerUI
var log: CombatLog
# TODO: Combat log? Other Combat UI elements
# TODO: Combat Animator?


func card_ability_triggered(
	card: CombatCard, 
	ability: Ability) -> void:
	# Find Card_UI (Card_UIs really only exist in the two hand/spread_piles rn)
	# Call update on card UI
	# Call any additional animations that might be required
	# >> its at this point we might need to do some more digging to find the card (e.g. if 
	#    its in the graveyard and we want it to do something or whatever
	
	# TODO: CAN HIGHLIGHT AND SELECT THE SPECIFIC ABILITY TOO
	# In fact, this really only has that purpose, of highlighting a card
	# ability or triggering an animation ability
	var p1_card_ui = p1_ui.hand.get_card_ui(card)
	var p2_card_ui = p2_ui.hand.get_card_ui(card)
	if p1_card_ui:
		p1_card_ui.update()
	elif p2_card_ui:
		p2_card_ui.update()
	else:
		pass


func on_ability_added(ability: Ability, target_card: CombatCard, source_ability: Ability, source_card: CombatCard) -> void:
	print('CARD ABILITY ADDED CALLED - ability: ', ability.get_name(), ', target_card: ', target_card.get_card_name(), ', source_card: ', source_card.get_card_name())
	
	log.log_event('> ' + source_ability.get_name().to_upper() + ' on card ' + source_card.get_card_name() + ' adds ability ' + ability.get_name().to_upper() + ' to ' + target_card.get_card_name())
	#not sure what to do with the source_card
	var p1_target_card_ui = p1_ui.hand.get_card_ui(target_card)
	var p2_target_card_ui = p2_ui.hand.get_card_ui(target_card)
	if p1_target_card_ui:
		p1_target_card_ui.update()
	elif p2_target_card_ui:
		p2_target_card_ui.update()
	else:
		pass
	await get_tree().create_timer(PROCESS_TIME).timeout
	

func on_ability_removed(ability: Ability, target_card: CombatCard, source_ability: Ability, source_card: CombatCard) -> void:
	#not sure what to do with the source_card
	log.log_event('> ' + source_ability.get_name().to_upper() + ' on card ' + source_card.get_card_name() + ' removed ability ' + ability.get_name().to_upper() + ' from ' + target_card.get_card_name())

	var p1_target_card_ui = p1_ui.hand.get_card_ui(target_card)
	var p2_target_card_ui = p2_ui.hand.get_card_ui(target_card)
	if p1_target_card_ui:
		p1_target_card_ui.update()
	elif p2_target_card_ui:
		p2_target_card_ui.update()
	else:
		pass
	await get_tree().create_timer(PROCESS_TIME).timeout


func on_abilities_removed(target_card: CombatCard, source_ability: Ability, source_card: CombatCard) -> void:
	#not sure what to do with the source_card
	log.log_event('> ' + source_ability.get_name().to_upper() + ' on card ' + source_card.get_card_name() + ' clears all added abilities from ' + target_card.get_card_name())

	
	var p1_target_card_ui = p1_ui.hand.get_card_ui(target_card)
	var p2_target_card_ui = p2_ui.hand.get_card_ui(target_card)
	if p1_target_card_ui:
		p1_target_card_ui.update()
	elif p2_target_card_ui:
		p2_target_card_ui.update()
	else:
		pass
	await get_tree().create_timer(PROCESS_TIME).timeout
