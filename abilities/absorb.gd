class_name Absorb
extends Ability


func get_name() -> String:
	return 'Absorb'

	
func get_description() -> String:
	return 'When this card is destroyed, gain HP equal to its power or toughness, whichever is higher. Void this card.'


func on_destroy(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> bool:
	var hp_boost = max(cur_card.get_power(), cur_card.get_toughness())
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' is absorbed by ' + cur_controller.stats.name + ' healing ' + str(hp_boost) + 'hp')
	cur_controller.stats.boost_hp(hp_boost)
	cur_controller.combat_cards.move_card(cur_card, CombatCardState.CardTarget.HAND, CombatCardState.CardTarget.VOID)	
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
	return false
