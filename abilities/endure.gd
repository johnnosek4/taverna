class_name Endure
extends Ability


func get_name() -> String:
	return 'Endure'

	
func get_description() -> String:
	return 'This card is not discarded at the end of turn.'


func on_discard(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> bool:
	# This prevents default behavior of moving card from hand to discard
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' endures!')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
	return false
