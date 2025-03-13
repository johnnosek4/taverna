class_name Forge
extends Ability


const NAME = "Forge"
const DESC = "When this card executes, it gives +1 Toughness to the lowest defense power card in your hand."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	var min_toughness_card = cur_card
	for card in cur_controller.combat_cards.hand:
		if card.get_toughness() < min_toughness_card.get_toughness():
			min_toughness_card = card
	var forged: Forged
	if min_toughness_card.has_ability_by_name(Forged.NAME):
		forged = min_toughness_card.get_ability_by_name(Forged.NAME) as Forged
		forged.state[forged.FORGED_AMOUNT] += 1
	else:
		forged = Forged.new()
		min_toughness_card.add_ability(forged)
	cur_controller.combat_log.log_event(min_toughness_card.get_card_name() + 'is FORGED with +1 Toughness by FORGE')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
