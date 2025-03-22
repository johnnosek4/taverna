# deck_item.gd
extends Button

var deck_data: Deck

@onready var deck_name_label = $HBoxContainer/DeckName
@onready var card_count_label = $HBoxContainer/CardCount

func _ready():
	update_display()
	
func update_display():
	if deck_data:
		deck_name_label.text = deck_data.name
		card_count_label.text = "%d cards" % deck_data.get_count()
