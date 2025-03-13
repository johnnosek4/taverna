class_name Restore
extends Ability


const NAME = "Restore"
const DESC = "When this hand executes, all cards in hand gain Heal."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC
	
	
func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.combat_log.log_event('All cards in ' + cur_controller.stats.name + ' gain HEAL via RESTORE')
	for card in cur_controller.combat_cards.hand:
		var heal = Heal.new()
		await card.add_ability(heal, self, cur_card)
	#await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
