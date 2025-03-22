class_name DeckEditor
extends Control

signal back_pressed
signal save_pressed(deck_data)

@onready var deck_name_edit: LineEdit = %DeckNameEdit
@onready var card_count_label: Label = %CardCountLabel
@onready var deck_cards_container: HFlowContainer = %DeckCards
@onready var collection_cards_container: HFlowContainer = %CollectionCards

var _card_database: CardDatabase
var collection: PlayerCollection
var current_deck: Deck
var deck_id: String
var card_display_scene = preload("res://ui/card_ui.tscn")

#func _ready():
	#load_cards_database()
	
func initialize(card_database, player_collection, deck_identifier):
	_card_database = card_database
	collection = player_collection
	deck_id = deck_identifier
	
	if deck_id and collection.decks.has(deck_id):
		current_deck = collection.decks[deck_id]
		deck_name_edit.text = current_deck.name
	else:
		current_deck = Deck.new()
		current_deck.id = collection.generate_unique_id()
		current_deck.name = "New Deck"
		current_deck.creation_date = Time.get_unix_time_from_system()
		current_deck.last_modified = current_deck.creation_date
		deck_name_edit.text = current_deck.name
		
	populate_deck_cards()
	populate_collection_cards()
	update_card_count()
	
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
	
func populate_deck_cards():
	# Clear existing
	for child in deck_cards_container.get_children():
		child.queue_free()
		
	# Add cards in deck
	for card_id in current_deck.cards:
		var card = _card_database.get_card(card_id)
		if card:
			var card_display = card_display_scene.instantiate()
			card_display.card = card
			card_display.connect("card_selected", _on_deck_card_selected)
			deck_cards_container.add_child(card_display)
			
			# ADD "count badge" based on the count
			var badge = Label.new()
			badge.text = str(current_deck.cards[card_id])
			card_display.add_child(badge)
			
			#badge.size_flags_horizontal = Control.SIZE_SHRINK_END
			#badge.size_flags_vertical = Control.SIZE_SHRINK_END
			

			badge.anchor_right = 1.0
			badge.anchor_bottom = 1.0
			badge.anchor_left = 1.0  # Keep right-aligned
			badge.anchor_top = 1.0   # Keep bottom-aligned
			# Adjust offset so it doesn't stretch (give it padding)
			badge.offset_left = -50  # 10px from the right
			badge.offset_top = -50  # 10px from the bottom
			
			
func populate_collection_cards():
	# Clear existing
	for child in collection_cards_container.get_children():
		child.queue_free()
		
	# Add unlocked cards
	for card_id in collection.unlocked_cards:
		var card = _card_database.get_card(card_id)
		if card:
			var card_display = card_display_scene.instantiate()
			card_display.card = card
			card_display.connect("card_selected", _on_collection_card_selected)
			collection_cards_container.add_child(card_display)


func update_card_count():
	card_count_label.text = "Cards: %d" % current_deck.get_count()


func _on_deck_card_selected(card_id):
	# Remove card from deck
	current_deck.remove_card(card_id)
	populate_deck_cards()
	update_card_count()


func _on_collection_card_selected(card_id):
	# Add card to deck
	current_deck.add_card(card_id)
	populate_deck_cards()
	update_card_count()


func _on_save_button_pressed():
	current_deck.name = deck_name_edit.text
	emit_signal("save_pressed", current_deck)


func _on_back_button_pressed():
	emit_signal("back_pressed")
