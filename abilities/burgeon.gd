class_name Burgeon
extends Ability


const NAME = "Burgeon"


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return 'When this hand executes, add a copy of this card to the discard pile.'


func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	var copy = cur_card.get_copy()
	cur_controller.combat_cards.add_card(copy, CombatCardState.CardTarget.DISCARD)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' Burgeons, adding a copy of itself to the Discard!')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
