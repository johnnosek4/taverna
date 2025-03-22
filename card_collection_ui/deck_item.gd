class_name DeckItem
extends HBoxContainer

var deck_data: Deck


@onready var deck_name_label: Label = %DeckName
@onready var card_count_label: Label = %CardCount
@onready var deck_detail_button: Button = %DeckDetailButton
@onready var delete_deck_button: Button = %DeleteDeckButton


func _ready():
	update_display()
	
func update_display():
	if deck_data:
		deck_name_label.text = deck_data.name
		card_count_label.text = "%d cards" % deck_data.get_count()
