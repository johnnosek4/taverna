class_name Gambit
extends CombatCard


const NAME = "Gambit"
const DESC = "Add 10 Attack; If Roll fails, destroy cards in Hand"


func _init() -> void:
	_base_attack = 10
	_base_fate_cost = 0.1
	_card_type = Type.OFFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Gambit:
	return Gambit.new()


func on_action_fails(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	var card_list = cur_controller.combat_cards.hand.duplicate()
	for card in card_list:
		await card.on_destroy(cur_controller, opp_controller)
