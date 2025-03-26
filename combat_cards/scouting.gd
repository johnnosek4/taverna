class_name Scouting
extends CombatCard


const NAME = "Scouting"
const DESC = "View the next card in your deck"

var peep_amount: int = 1


func _init() -> void:
	_id = '028'
	_base_fate_cost = 0.1
	_card_type = Type.CHAOTIC


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Scouting:
	return Scouting.new()


func on_draw(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	cur_controller.combat_cards.peep_deck(peep_amount)
