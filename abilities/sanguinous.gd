class_name Sanguinous
extends Ability


const NAME = "Sanguinous"
const DESC = "When this card is played, if your HP is at or above your starting HP, destroy it."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_draw(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	# NOTE: currently working off the structure that on_draw is called after the card is moved to the hand
	if cur_controller.stats.current_health > cur_controller.stats.max_health:
		cur_controller.combat_log.log_event(cur_card.get_card_name() + ' destroys itself via SANGUINOUS')
		cur_controller.combat_cards.move_card(cur_card, CombatCardState.CardTarget.HAND, CombatCardState.CardTarget.GRAVEYARD)
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
