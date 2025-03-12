class_name Sly
extends Ability


const NAME = "Sly"
const DESC = "If this card doesn’t execute, this card loses Sly and gains Fateless and Endure."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC
	
	
func on_action_fails(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_card.add_ability(Fateless.new())
	cur_card.add_ability(Endure.new())
	cur_card.remove_ability(Sly.new())
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' gains Fateless and Endure, losing Sly via Sly')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
