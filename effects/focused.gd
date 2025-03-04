class_name Focused
extends Effect

var base_modifier: float = 1.1
const name := "Focused"


func get_name() -> String:
	return name
	

func modify_roll_probability(prob: float) -> float:
	return prob * base_modifier
