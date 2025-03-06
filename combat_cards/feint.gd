class_name Feint
extends CombatCard

const name := 'Feint'
#var base_dmg: int = 5
#var multiplier: float = 1.5


func _init():
	probability = 0.9


func apply_run_effect(
	logger: CombatLog,
	run_index: int,
	current_controller: PlayerController,
	opponent_controller: PlayerController
	) -> void:

	print('evaluate: ', name)
	var vulnerable = Vulnerable.new()
	vulnerable.duration = 2
	opponent_controller.stats.add_effect(vulnerable)
	logger.log_event(current_controller.stats.name + ' feints, applying vulnerable to ' + opponent_controller.stats.name)



func get_card_name() -> String:
	return name

	
func get_card_description() -> String:
	return 'apply `vulnerable` to opponent for 1 turn'


func get_probabilty() -> float:
	return self.probability
	

func get_copy() -> CombatCard:
	return Feint.new()
