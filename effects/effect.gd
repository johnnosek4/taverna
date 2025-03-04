class_name Effect
extends RefCounted

var duration: int = 1


func get_name() -> String:
	return 'not implemented'


func modify_damage_taken(dmg: int) -> int:
	return dmg
	
	
func modify_damage_dealt(dmg: int) -> int:
	return dmg


func modify_roll_probability(prob: float) -> float:
	return prob
