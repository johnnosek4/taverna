class_name Disengage
extends CombatCard

const name := 'Disengage'


func on_draw_effect(
	logger: CombatLog,
	roll_run: Callable,
	current_controller: PlayerController,
	opponent_controller: PlayerController
	) -> void:
	print('Disengage played - Clears all combat effects!')
	roll_run.call(current_controller, opponent_controller)
	current_controller.stats.clear_effects()
	opponent_controller.stats.clear_effects()
	current_controller.end_turn()
		
	'''
	so in order to accomplish 1) end round, roll, and clear effects
	we may need to rethink structure a bit.
	ALSO, note that there are other cards like Segue which
	roll the run and then continue the round, so maybe we want either
	1) to pass in callbacks for more granular game mechanics:
		e.g. roll the run (though i cant think of that many more
		besides that and draw a card)
	^I think given that this is a prototype, this seems like the
	easiest path forward based on what we have
	2) or? do we have a game controller that is passed between or is
		a shared reference of the two player controllers that sit
		alongside it, and then they all exist as childen of the combat scene
	3) ORRR? does the game machine have no state, and just exists as
		a set of functions that the two controllers are able to manipulate
	'''
	pass


func get_card_name() -> String:
	return name

	
func get_card_description() -> String:
	return 'roll; clear all effects from both combatants; end turn'


func get_probabilty() -> float:
	return self.probability
	
func get_copy() -> CombatCard:
	return Disengage.new()
