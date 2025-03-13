class_name Purify
extends Ability


const NAME = "Purify"
const DESC = "When this card executes, remove all added abilities (good or bad) from all cards in play."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	for card in opp_controller.combat_cards.hand:
		card.clear_added_abilities(self, cur_card)
	for card in cur_controller.combat_cards.hand:
		card.clear_added_abilities(self, cur_card)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' PURIFIES all cards in Action, wiping added abilities!')
	#await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
