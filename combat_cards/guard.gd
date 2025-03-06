class_name Guard
extends CombatCard

const name := 'Guard'
#var base_dmg: int = 5
#var multiplier: float = 1.5


func _init():
	probability = 1.0


func apply_run_effect(
	logger: CombatLog,
	run_index: int,
	current_controller: PlayerController,
	opponent_controller: PlayerController
	) -> void:

	print('evaluate: ', name)
	var protected = Protected.new()
	current_controller.stats.add_effect(protected)
	logger.log_event(current_controller.stats.name + ' enters guard, applying protected to themself')


func get_card_name() -> String:
	return name

	
func get_card_description() -> String:
	return 'gain `protected` for 1 turn'


func get_probabilty() -> float:
	return self.probability
	
func get_copy() -> CombatCard:
	return Guard.new()
