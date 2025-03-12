class_name Armor
extends Ability


const NAME = "Armor"
const DESC = "If this card would be destroyed, remove armor and discard it instead."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_destroy(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> bool:
	cur_card.remove_ability(Armor.new())
	cur_controller.combat_cards.move_card(cur_card, CombatCardState.CardTarget.HAND, CombatCardState.CardTarget.DISCARD)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' loses ARMOR but averts destruction and is discarded instead.')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
	return false
