class_name Protected
extends Effect

var base_modifier: float = 0.66
const name := "Protected"


func get_name() -> String:
	return name
	

func modify_damage_taken(dmg: int) -> int:
	return dmg * base_modifier
