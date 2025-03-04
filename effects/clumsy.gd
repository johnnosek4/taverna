class_name Clumsy
extends Effect

var base_modifier: float = 0.5
const name := "Clumsy"


func get_name() -> String:
	return name
	

func modify_damage_dealt(dmg: int) -> int:
	print('clumsy return damage: '+ str(dmg * base_modifier))
	return dmg * base_modifier
