class_name Heal
extends Ability


const NAME = "Heal"
const DESC = "When this hand executes, gain +1 HP."

var hp_boost: int = 1


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.stats.boost_hp(hp_boost)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' heals ' + cur_controller.stats.name + ' +1 hp via HEAL')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
