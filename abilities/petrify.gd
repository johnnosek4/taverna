class_name Petrify
extends Ability


const NAME = "Petrify"
const DESC = "When this card executes, all enemy cards gain brittle."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	for card in opp_controller.combat_cards.hand:
		var brittle = Brittle.new()
		card.add_ability(brittle)
	cur_controller.combat_log.log_event(opp_controller.stats.name + '`s hand is PETRIFIED, all cards gain BRITTLE!')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
