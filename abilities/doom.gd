class_name Doom
extends Ability


const NAME = "Doom"
const DESC = "When this card fails to execute, destroy it."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_action_fails(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' is Doomed and is destroyed!')
	cur_controller.combat_cards.move_card(cur_card, CombatCardState.CardTarget.HAND, CombatCardState.CardTarget.GRAVEYARD)
