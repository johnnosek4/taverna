class_name CombatCard
extends Resource


var probability: float = 0.9


func get_card_name() -> String:
	return "not implemented"


func get_card_description() -> String:
	return "not implemented"


func get_probability() -> float:
	return probability


func apply_run_effect(
	logger: CombatLog,
	run_index: int,
	current_controller: PlayerController,
	opponent_controller: PlayerController
	) -> void:
	pass


func on_draw_effect(
	logger: CombatLog,
	roll_run: Callable,
	current_controller: PlayerController,
	opponent_controller: PlayerController
	) -> void:
	pass


func get_copy() -> CombatCard:
	print('WARNING: NOT IMPLEMENTED')
	return CombatCard.new()
