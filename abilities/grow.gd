class_name Grow
extends Ability

const NAME = "Grow"

var toughness_increase: int = 0


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return 'When you this card wins defense it gains, +1 Toughness.'


func modify_toughness(toughness: int) -> int:
	return toughness + toughness_increase


func on_defend_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' Grows, gaining +1 Toughness!')
	toughness_increase += 1
