# card_display.gd
extends Control

signal card_selected(card_id)

@export var card_data: Card

@onready var card_image = $CardImage
@onready var card_name = $CardName
@onready var card_type = $CardType

func _ready():
	update_display()
	
func update_display():
	if card_data:
		card_name.text = card_data.name
		card_type.text = card_data.card_type
		if ResourceLoader.exists(card_data.image_path):
			card_image.texture = load(card_data.image_path)
			
func _on_pressed():
	emit_signal("card_selected", card_data.id)
