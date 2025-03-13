class_name Armorer
extends Ability


const NAME = "Armorer"
const DESC = "When this card executes, it gives armor to all cards in hand."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC
	
	
func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	for card in cur_controller.combat_cards.hand:
		var armor = Armor.new()
		await card.add_ability(armor, self, cur_card)
		
	#
		##NOTE: testing UI controller card ability updates using this
		#cur_controller.combat_ui_manager.card_ability_added(armor, card, cur_card)
	#
	cur_controller.combat_log.log_event('All cards in ' + cur_controller.stats.name + '`s hand gain `ARMOR` via ARMORER!')
	#await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
