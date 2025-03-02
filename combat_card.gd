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
	run_index: int,
	current_stats: Stats, 
	noncurrent_stats: Stats,
	current_player_card_state: CombatCardState,
	noncurrent_player_card_state: CombatCardState,
	) -> void:
	pass

