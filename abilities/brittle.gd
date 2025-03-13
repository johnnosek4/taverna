class_name Brittle
extends Ability


const NAME = "Brittle"
const DESC = "Destroy this card after it defends."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC
	

func on_defend_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.combat_cards.move_card(cur_card, CombatCardState.CardTarget.HAND, CombatCardState.CardTarget.GRAVEYARD)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' is BRITTLE and crumbles after a succesful Defense!')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout

		
