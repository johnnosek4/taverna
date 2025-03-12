class_name Venom
extends Ability


const NAME = "Venom"
const DESC = "When you win defense, destroy attacking cards."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC
	

func on_defend_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	# NOTE/TODO: not sure if this dupe is necessary
	var opp_hand = opp_controller.combat_cards.hand.duplicate()
	for card in opp_hand:
		opp_controller.combat_cards.move_card(card, CombatCardState.CardTarget.HAND, CombatCardState.CardTarget.GRAVEYARD)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' destroys all cards in the opponents hand via Venom')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
