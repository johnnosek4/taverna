class_name Feed
extends Ability

const NAME = "Feed"

var power_increase: int = 0


func get_name() -> String:
	return NAME
	

func get_description() -> String:
	return 'When this card wins attack, it gains +1 Power.'


func modify_power(power: int) -> int:
	return power + power_increase
	

func on_attack_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' FEEDS, gaining +1 Attack!')
	power_increase += 1
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
