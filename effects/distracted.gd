class_name Distracted
extends Effect

var base_modifier: float = 0.8
const name := "Distracted"


func get_name() -> String:
	return name
	

func modify_roll_probability(prob: float) -> float:
	return prob * base_modifier
