class_name Lunge
extends CombatCard

const name := 'Lunge'
var base_dmg: int = 5
var multiplier: float = 1.5


func _init():
	probability = 0.8


func apply_run_effect(
	run_index: int,
	current_stats: Stats, 
	noncurrent_stats: Stats,
	current_player_card_state: CombatCardState,
	noncurrent_player_card_state: CombatCardState,
	) -> void:
	var dmg = base_dmg
	if run_index != 0:
		if current_player_card_state.run[run_index-1].get('base_dmg'):
			dmg = current_player_card_state.run[run_index-1].base_dmg * multiplier
	print('evaluate: ', name)
	print('noncurrent: ', noncurrent_stats.name)
	print('dmg: ', dmg)
	noncurrent_stats.current_health -= dmg
	print('health after: ', noncurrent_stats.current_health)
	current_stats.add_effect(Stats.Effect.VULNERABLE)


func get_card_name() -> String:
	return name

	
func get_card_description() -> String:
	return 'deal ' + str(multiplier) + ' the damage of the prior card, or ' + str(base_dmg) + ' if there is no prior card'
	
func get_probabilty() -> float:
	return self.probability
