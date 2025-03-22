class_name Harbinger
extends CombatCard


const NAME = "Harbinger"
const DESC = "This Card has no effect the first time it's played; The next time it's played gain 1x Attack Mult"

var _attack_mult: float = 1.0
var _played_count: int = 0
var _played_count_threshold: int = 1


func _init() -> void:
	_id = "014"
	_base_fate_cost = 0.1
	_card_type = Type.CHAOTIC


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC + '(' + str(_played_count) + ')'
	

func get_attack_mult(hand: Array[CombatCard]) -> float:
	if _played_count <= _played_count_threshold:
		return _base_attack_mult
	else:
		return _attack_mult


func get_copy() -> Harbinger:
	return Harbinger.new()


func on_draw(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	_played_count += 1
