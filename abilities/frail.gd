class_name Frail
extends Ability


const NAME = "Frail"
const DESC = "If this card is in a hand that doesn’t execute, destroy it."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_action_fails(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	await cur_controller.combat_cards.move_card(cur_card, CombatCardState.CardTarget.HAND, CombatCardState.CardTarget.GRAVEYARD)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' is FRAIL and is destroyed upon failed Action')
	#await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
