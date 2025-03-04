class_name Lethal
extends Effect

var base_modifier: float = 1.5
const name := "Lethal"


func get_name() -> String:
	return name
	

func modify_damage_dealt(dmg: int) -> int:
	print('lethal return damage: '+ str(dmg * base_modifier))
	return dmg * base_modifier
