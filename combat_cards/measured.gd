class_name Measured
extends CombatCard

const name := 'Measured'
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
	var focused = Focused.new()
	focused.duration = 2
	current_controller.stats.add_effect(focused)


func get_card_name() -> String:
	return name

	
func get_card_description() -> String:
	return 'apply `focused` to self for 1 turn'


func get_probabilty() -> float:
	return self.probability
	
func get_copy() -> CombatCard:
	return Measured.new()
