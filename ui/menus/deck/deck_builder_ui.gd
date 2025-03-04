extends ColorRect

var stats: Stats

const card_view_scene = preload("res://ui/menus/deck/deck_building_card_view.tscn")

@onready var grid_container: GridContainer = %GridContainer
@onready var save_button: Button = %SaveButton
@onready var close_button: Button = %CloseButton


func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	save_button.pressed.connect(_generate_new_card_pile)
	generate_card_views()

	
func generate_card_views() -> void:
	for card in stats.card_pile:
		var card_view = card_view_scene.instantiate()
		card_view.combat_card = card
		card_view.card_count = stats.card_pile[card]
		grid_container.add_child(card_view)


func _generate_new_card_pile() -> void:
	var card_pile = {}
	for card_view in grid_container.get_children():
		card_pile[card_view.combat_card] = card_view.card_count
	stats.card_pile = card_pile


func _on_close_button_pressed() -> void:
	queue_free()
