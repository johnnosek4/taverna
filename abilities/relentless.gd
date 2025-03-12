class_name Relentless
extends Ability


const NAME = "Relentless"
const DESC = "Instead of this card going to the discard pile at the end of a turn, this card shuffles back into the draw pile."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_discard(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> bool:
	var copy = cur_card.get_copy()
	cur_controller.combat_cards.move_card(copy, CombatCardState.CardTarget.HAND, CombatCardState.CardTarget.DECK)
	cur_controller.combat_cards.deck.shuffle() #TODO: may want a wrapper function to control signalling, animations, etc
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' is Relentless, going back to the draw pile instead of discard!')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
	return false
