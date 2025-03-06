class_name Lunge
extends CombatCard

const name := 'Lunge'
var base_dmg: int = 5
var multiplier: float = 1.5


func _init():
	probability = 0.8


func apply_run_effect(
	logger: CombatLog,
	run_index: int,
	current_controller: PlayerController,
	opponent_controller: PlayerController
	) -> void:
	var dmg = base_dmg
	if run_index != 0:
		if current_controller.combat_cards.run[run_index-1].get('base_dmg'):
			dmg = current_controller.combat_cards.run[run_index-1].base_dmg * multiplier
	print('evaluate: ', name)
	
	var dmg_dealt = current_controller.stats.modify_damage_dealt(dmg)
	opponent_controller.stats.apply_damage(dmg_dealt)
	
	logger.log_event(current_controller.stats.name + ' lunges, dealing ' + str(dmg_dealt) + ' to ' + opponent_controller.stats.name + ', becoming vulnerable to retaliation')
	var vulnerable = Vulnerable.new()
	vulnerable.duration = 2
	current_controller.stats.add_effect(vulnerable)




func get_card_name() -> String:
	return name

	
func get_card_description() -> String:
	return 'deal ' + str(multiplier) + ' the damage of the prior card, or ' + str(base_dmg) + ' if there is no prior card'
	
func get_probabilty() -> float:
	return self.probability
	
func get_copy() -> CombatCard:
	return Lunge.new()
