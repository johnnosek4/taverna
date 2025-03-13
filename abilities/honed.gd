class_name Honed
extends Ability


const NAME = "Honed"
const DESC = "Granted additional Power from Hone"
const HONED_AMOUNT = "Honedx"


func _init() -> void:
	state[HONED_AMOUNT] = 1


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func modify_power(power: int) -> int:
	return power + state[HONED_AMOUNT]
