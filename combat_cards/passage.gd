class_name Passage
extends CombatCard

const name := 'Passage'


func on_draw_effect(
	logger: CombatLog,
	roll_run: Callable,
	current_controller: PlayerController,
	opponent_controller: PlayerController
	) -> void:
	print('evaluate: ', name)
	logger.log_event(current_controller.stats.name + ' performs a pass, rolling the current run and starting a new one!')
	await roll_run.call(current_controller, opponent_controller)


func get_card_name() -> String:
	return name

	
func get_card_description() -> String:
	return 'roll run; continue round'


func get_probabilty() -> float:
	return self.probability
	

func get_copy() -> CombatCard:
	return Passage.new()
