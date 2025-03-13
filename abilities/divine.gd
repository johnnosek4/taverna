class_name Divine
extends Ability


const NAME = "Divine"
const DESC = "When this hand executes, all cards in hand gain Fateless."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	for card in cur_controller.combat_cards.hand:
		var fateless = Fateless.new()
		card.add_ability(fateless)
	cur_controller.combat_log.log_event('All cards in ' + cur_controller.stats.name + '`s hand gain FATELESS via DIVINE!')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
