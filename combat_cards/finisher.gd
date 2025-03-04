class_name Finisher
extends CombatCard

const name := 'Finisher'

'''
Dev note: its a little janky how this applies lethal even if the roll fails
could solve this by having this functionality moved to an apply_run_effect method
but that wouldnt even solve the problem, as that would apply the multiplier too late
this brings up a good question tho, do we want the effects added as the cards
are played, or do we want a 'prior to run' method on all cards where they can
apply modifiers prior to the run being calculated?
This wouldn't be that much additional effort if we did decide that we 
wanted to do it
'''


func _init():
	probability = 0.8


func on_draw_effect(
	logger: CombatLog,
	roll_run: Callable,
	current_controller: PlayerController,
	opponent_controller: PlayerController
	) -> void:
		
	logger.log_event(current_controller.stats.name + ' plays ' + name)
	
	var lethal = Lethal.new()
	current_controller.stats.add_effect(lethal)
	
	roll_run.call(current_controller, opponent_controller)
	
	current_controller.end_turn()


func get_card_name() -> String:
	return name
	
func get_card_description() -> String:
	return 'apply `lethal` to self; roll run; end round'
	
func get_probabilty() -> float:
	return self.probability
	
func get_copy() -> CombatCard:
	return Finisher.new()
