class_name SpreadPileUI
extends PileUI

const card_ui_scene = preload("res://ui/card_ui.tscn")

#var card_state: CombatCardState #this could be used for syncing, but not technically necessary as of right now
var card_width: int
var card_offset: int = 10

@onready var card_spread_hbox: HBoxContainer = %CardSpreadHBox


func _ready() -> void:
	var card_ui = card_ui_scene.instantiate()
	card_width = card_ui.size.x
	#card_offset = card_spread_hbox.get_constant("separation")


func add_card(card: CombatCard) -> void:
	var card_ui = card_ui_scene.instantiate()
	card_ui.card = card
	card_spread_hbox.add_child(card_ui)
	

func remove_card(card: CombatCard) -> void:
	for child in card_spread_hbox.get_children():
		if child.card == card:
			child.queue_free()

		
func get_add_location() -> Vector2:
	var index = card_spread_hbox.get_child_count()
	return Vector2(global_position.x + (index * (card_width+card_offset)), global_position.y)


func get_remove_location(card: CombatCard) -> Vector2:
	for child in card_spread_hbox.get_children():
		if child.card == card:
			return child.global_position
	print('ERROR - card not located in SpreadPileUI children')
	return global_position


func get_card_ui(card: CombatCard) -> CardUI:
	var card_ui: CardUI
	for child in card_spread_hbox.get_children():
		if child.card == card:
			card_ui = child
	return card_ui
	

	
