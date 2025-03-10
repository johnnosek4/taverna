#class_name Strike
#extends CombatCard
#
#const name := 'Strike'
#var base_dmg: int = 5
#
#
#func _init():
	#probability = 0.8
#
#
#func apply_run_effect(
	#logger: CombatLog,
	#run_index: int,
	#current_controller: PlayerController,
	#opponent_controller: PlayerController
	#) -> void:
	#print('evaluate: ', name)
	#var dmg_dealt = current_controller.stats.modify_damage_dealt(base_dmg)
	#opponent_controller.stats.apply_damage(dmg_dealt)
	#logger.log_event(current_controller.stats.name + ' executes a strike for ' + str(dmg_dealt) + ' damage!')
#
#
#func get_card_name() -> String:
	#return name
	#
#func get_card_description() -> String:
	#return 'deal ' + str(base_dmg) + ' damage'
	#
#func get_probabilty() -> float:
	#return self.probability
	#
#func get_copy() -> CombatCard:
	#return Strike.new()
