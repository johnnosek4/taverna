class_name PileUI
extends Control


func add_card(_card: CombatCard) -> void:
	pass
	

func remove_card(_card: CombatCard) -> void:
	pass

		
func get_add_location() -> Vector2:
	return global_position


func get_remove_location(card: CombatCard) -> Vector2:
	return global_position
