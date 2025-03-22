class_name Pyrrhic
extends CombatCard


const NAME = "Pyrrhic"
const DESC = "Add 5 Attack; Add 1x Attack Mult; Destroy top card in Deck"


func _init() -> void:
	_id = "020"
	_base_attack = 5
	_base_attack_mult = 1.0
	_base_fate_cost = 0.1
	_card_type = Type.OFFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Pyrrhic:
	return Pyrrhic.new()


func on_draw(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	var top_card = cur_controller.combat_cards.deck[-1]
	cur_controller.combat_cards.move_card(top_card, CombatCardState.CardTarget.DECK, CombatCardState.CardTarget.GRAVEYARD)
