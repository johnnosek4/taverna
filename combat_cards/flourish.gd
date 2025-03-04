class_name Flourish
extends CombatCard

const name := 'Flourish'
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
	var distracted = Distracted.new()
	distracted.duration = 2
	opponent_controller.stats.add_effect(distracted)


func get_card_name() -> String:
	return name

	
func get_card_description() -> String:
	return 'apply `distracted` to opponent for 1 turn'


func get_probabilty() -> float:
	return self.probability
	
func get_copy() -> CombatCard:
	return Flourish.new()
