class_name Strike
extends CombatCard

const name := 'Strike'
var base_dmg: int = 5

func _init():
	probability = 0.8

func apply_run_effect(
	run_index: int,
	current_stats: Stats, 
	noncurrent_stats: Stats,
	current_player_card_state: CombatCardState,
	noncurrent_player_card_state: CombatCardState,
	) -> void:
	#deal 5 dmg to the noncurrent player stats
	print('evaluate: ', name)
	print('noncurrent: ', noncurrent_stats.name)
	noncurrent_stats.current_health -= base_dmg
	print('health after: ', noncurrent_stats.current_health)

func get_card_name() -> String:
	return name
	
func get_card_description() -> String:
	return 'deal ' + str(base_dmg) + ' damage'
	
func get_probabilty() -> float:
	return self.probability
