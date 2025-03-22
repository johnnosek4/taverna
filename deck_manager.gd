class_name DeckManager
extends Node

var collection_view_scene = preload("res://card_collection_ui/collection_view.tscn")
var deck_editor_scene = preload("res://card_collection_ui/deck_editor.tscn")

var current_view: Control
var player_collection: PlayerCollection
var card_database: CardDatabase


func complete_setup() -> void:
	show_collection_view()


func show_collection_view():
	# Remove existing view
	if current_view:
		current_view.queue_free()
		
	# Create collection view
	current_view = collection_view_scene.instantiate()
	current_view.collection = player_collection
	current_view.card_database = card_database
	add_child(current_view)
	
	# Connect signals
	current_view.connect("back_pressed", _on_back_to_main_menu)
	current_view.connect("deck_selected", _on_deck_selected)
	current_view.connect("create_deck_pressed", _on_create_deck_pressed)


func show_deck_editor(deck_id = ""):
	# Remove existing view
	if current_view:
		current_view.queue_free()
		
	# Create deck editor
	current_view = deck_editor_scene.instantiate()
	add_child(current_view)
	
	# Initialize editor
	current_view.initialize(card_database, player_collection, deck_id)
	
	# Connect signals
	current_view.connect("back_pressed", _on_back_to_collection)
	current_view.connect("save_pressed", _on_save_deck)
	
func _on_back_to_main_menu():
	print('ON BACK TO MAIN MENU CALLED')
	queue_free()
	
func _on_back_to_collection():
	show_collection_view()
	
func _on_deck_selected(deck_id):
	show_deck_editor(deck_id)
	
func _on_create_deck_pressed():
	show_deck_editor()
	
func _on_save_deck(deck_data):
	player_collection.decks[deck_data.id] = deck_data

		
	player_collection.save_collection()
	show_collection_view()
