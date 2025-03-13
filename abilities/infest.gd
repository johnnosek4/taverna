class_name Infest
extends Ability


const NAME = "Infest"
const DESC = "When this card executes, all enemy cards gain Parasite."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	for card in opp_controller.combat_cards.hand:
		var parasite = Parasite.new()
		await card.add_ability(parasite, self, cur_card)
	cur_controller.combat_log.log_event(opp_controller.stats.name + '`s hand becomes INFESTED, all cards gain PARASITE!')
	#await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
