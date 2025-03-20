class_name Martyr
extends CombatCard


const NAME = "Martyr"
const DESC = "Add 3 Defense; Heal 2 HP on Discard"

var _heal_amount: int = 2

func _init() -> void:
	_base_defense = 3
	_base_fate_cost = 0.1
	_card_type = Type.DEFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> Martyr:
	return Martyr.new()


func on_discard(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	cur_controller.stats.boost_hp(_heal_amount)
	super.on_discard(cur_controller, opp_controller)
