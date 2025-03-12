class_name Siphon
extends Ability


const NAME = "Siphon"
const DESC = "When this card wins defense, gain +1HP."

var hp_boost: int = 1

func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_defend_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.stats.boost_hp(hp_boost)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' heals ' + cur_controller.stats.name + ' +1 hp via Siphon')
