class_name Parasite
extends Ability


const NAME = "Parasite"
const DESC = "Whenever this card is played, reduce your HP by 1."

var hp_drain: int = 1


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_draw(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.stats.apply_damage(hp_drain)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' drains ' + str(hp_drain) + ' hp from its host ' + cur_controller.stats.name)
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
