class_name CollectionView
extends Control

signal back_pressed
signal deck_selected(deck_id)
signal create_deck_pressed

@onready var card_grid: HFlowContainer = %CardGrid
@onready var deck_list: VBoxContainer = %DeckList
@onready var back_button: Button = %BackButton
@onready var create_deck_button: Button = %CreateDeckButton


var collection: PlayerCollection
var card_database: CardDatabase
var card_display_scene = preload("res://ui/card_ui.tscn")
var deck_item_scene = preload("res://card_collection_ui/deck_item.tscn")


#func complete_setup() -> void:
	#populate_card_grid()
	#populate_deck_list()

func _ready():
	back_button.pressed.connect(_on_back_button_pressed)
	create_deck_button.pressed.connect(_on_create_deck_button_pressed)
	populate_card_grid()
	populate_deck_list()

	
#func load_cards_database():
	#var file = FileAccess.open("res://data/cards.json", FileAccess.READ)
	#var json = JSON.parse_string(file.get_as_text())
	#
	#for card_data in json:
		#var card = Card.new()
		#card.id = card_data.id
		#card.name = card_data.name
		#card.description = card_data.description
		#card.image_path = card_data.image_path
		#card.card_type = card_data.card_type
		#card.rarity = card_data.rarity
		#card.attributes = card_data.attributes
		#cards_database[card.id] = card
		
#func load_player_collection():
	#collection.load_collection()


func populate_card_grid():
	# Clear existing
	for child in card_grid.get_children():
		child.queue_free()
		
	# Add unlocked cards
	for card_id in collection.unlocked_cards:
		var card_instance = card_database.get_card(card_id)
		if card_instance:
			var card_display = card_display_scene.instantiate() as CardUI
			card_display.card = card_instance
			#card_display.connect("card_selected", _on_card_selected)
			card_grid.add_child(card_display)


func populate_deck_list():
	# Clear existing
	for child in deck_list.get_children():
		child.queue_free()
		
	# Add decks
	for deck_id in collection.decks:
		var deck = collection.decks[deck_id]
		var deck_item = deck_item_scene.instantiate()
		deck_item.deck_data = deck
		deck_item.connect("pressed", func(): _on_deck_selected(deck_id))
		deck_list.add_child(deck_item)


#func _on_card_selected(card_id):
	## Show card details popup
	#var details_popup = $CardDetailsPopup
	#details_popup.display_card(cards_database[card_id])
	#details_popup.show()
	
func _on_deck_selected(deck_id):
	emit_signal("deck_selected", deck_id)
	
func _on_create_deck_button_pressed():
	emit_signal("create_deck_pressed")
	
func _on_back_button_pressed():
	emit_signal("back_pressed")
