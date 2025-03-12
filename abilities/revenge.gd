class_name Revenge
extends Ability


const NAME = "Revenge"
const DESC = "When this card defends, reduce enemy health by this card’s power."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_defend_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' deals ' + str(cur_card.get_power()) + ' to ' + opp_controller.stats.name + 'via Revenge!')
	opp_controller.stats.apply_damage(cur_card.get_power())
