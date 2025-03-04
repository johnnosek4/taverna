class_name Vulnerable
extends Effect

var base_modifier: float = 1.5
const name := "Vulnerable"


func get_name() -> String:
	return name
	

func modify_damage_taken(dmg: int) -> int:
	return dmg * base_modifier
