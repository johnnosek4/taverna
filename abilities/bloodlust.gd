class_name Bloodlust
extends Ability


func get_name() -> String:
	return 'Bloodlust'

	
func get_description() -> String:
	return 'When this card wins attack, it gains endure.'
	
	
func on_attack_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	var endure = Endure.new()
	cur_card.add_ability(endure)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' gains `Endure`!')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
