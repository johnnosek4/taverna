class_name Forged
extends Ability


const NAME = "Forged"
const DESC = "Granted additional Toughness from Forge"
const FORGED_AMOUNT = "Forgedx"


func _init() -> void:
	state[FORGED_AMOUNT] = 1


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func modify_toughness(toughness: int) -> int:
	return toughness + state[FORGED_AMOUNT]
