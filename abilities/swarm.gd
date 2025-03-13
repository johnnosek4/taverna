class_name Swarm
extends Ability


const NAME = "Swarm"
const DESC = "When this card is played, if there is a copy of it in the draw pile, draw and play a copy of it as well."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_draw(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	var copy = cur_controller.combat_cards.return_first_instance(cur_card, CombatCardState.CardTarget.DECK)
	if copy:
		await cur_controller.combat_cards.move_card(copy, CombatCardState.CardTarget.DECK, CombatCardState.CardTarget.HAND)
		cur_controller.combat_log.log_event(cur_card.get_card_name() + ' SWARMS, adding another copy to the Hand from the Deck')
		#await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
