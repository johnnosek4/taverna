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
	#TODO: not actually sure how you do this, but I think
	#we need like a state setter, which when you update
	#ability state, then calls update state on the owning card
	#though right now abilities dont know who owns them, which
	#like, so you could just have update state on the card
	#but the card doesn't have access to its UI, lol....
	#maybe a modify_ability on the card, just like add abiilty
	#HEY!! that could work!
	if min_toughness_card.has_ability_by_name(Forged.NAME):
		forged = min_toughness_card.get_ability_by_name(Forged.NAME) as Forged
		forged.state[forged.FORGED_AMOUNT] += 1
	else:
		forged = Forged.new()
		await min_toughness_card.add_ability(forged, self, cur_card)
	cur_controller.combat_log.log_event(min_toughness_card.get_card_name() + 'is FORGED with +1 Toughness by FORGE')
	#await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
