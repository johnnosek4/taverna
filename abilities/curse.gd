class_name Curse
extends Ability


const NAME = "Curse"
const DESC = "When this card executes, all enemy cards gain doom."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC
	
	
func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' Dooms ' + opp_controller.stats.name + '`s hand via Curse!')
	for card in opp_controller.combat_cards.hand:
		var doom = Doom.new()
		card.add_ability(doom)
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
