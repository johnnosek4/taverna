class_name Bash
extends CombatCard

const name := 'Bash'
var base_dmg: int = 7


func _init():
	probability = 0.7


func apply_run_effect(
	logger: CombatLog,
	run_index: int,
	current_controller: PlayerController,
	opponent_controller: PlayerController
	) -> void:
	logger.log_event(current_controller.stats.name + ' deals ' + str(base_dmg))
	var dmg_dealt = current_controller.stats.modify_damage_dealt(base_dmg)
	opponent_controller.stats.apply_damage(dmg_dealt)
	var clumsy = Clumsy.new()
	clumsy.duration = 2
	logger.log_event(current_controller.stats.name + ' applies `clumsy` to ' + opponent_controller.stats.name)
	opponent_controller.stats.add_effect(clumsy)


func get_card_name() -> String:
	return name
	
func get_card_description() -> String:
	return 'deal ' + str(base_dmg) + ' damage; apply `clumsy` to opponent'
	
func get_probabilty() -> float:
	return self.probability
	
func get_copy() -> CombatCard:
	return Bash.new()
