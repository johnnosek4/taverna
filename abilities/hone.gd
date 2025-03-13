class_name Hone
extends Ability


const NAME = "Hone"
const DESC = "When this card executes it gives +1 Power to the lowest attack power card in your hand."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_action_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	var min_attack_card = cur_card
	#TODO: see the same issue as forged
	for card in cur_controller.combat_cards.hand:
		if card.get_power() < min_attack_card.get_power():
			min_attack_card = card
	var honed: Honed
	if min_attack_card.has_ability_by_name(Honed.NAME):
		honed = min_attack_card.get_ability_by_name(Honed.NAME) as Honed
		honed.state[Honed.HONED_AMOUNT] += 1
	else:
		honed = Honed.new()
		await min_attack_card.add_ability(honed, self, cur_card)
	cur_controller.combat_log.log_event(min_attack_card.get_card_name() + 'is HONED with +1 Power by HONE')
	#await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
