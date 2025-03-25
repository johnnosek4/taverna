class_name SPMatchMenu
extends Control


const COMBAT_SCENE = preload("res://combat_scene.tscn")

var player_collection: PlayerCollection
var view_controller: ViewController
var deck_list: Array[Deck]
var id_for_random: int

@onready var p1_deck_selector_button: OptionButton = %P1DeckSelectorButton
@onready var p2_deck_selector_button: OptionButton = %P2DeckSelectorButton
@onready var back_button: Button = %BackButton
@onready var start_match_button: Button = %StartMatchButton


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	start_match_button.pressed.connect(_on_start_match_button_pressed)
	populate_selector_buttons()


func populate_selector_buttons() -> void:
	deck_list = []
	var idx = 0
	for deck_id in player_collection.decks:
		var deck = player_collection.decks[deck_id]
		deck_list.append(deck)
		p1_deck_selector_button.add_item(deck.name, idx)
		p2_deck_selector_button.add_item(deck.name, idx)
		idx += 1
	idx += 1
	id_for_random = idx
	p1_deck_selector_button.add_item('Dealers Choice', id_for_random)
	p2_deck_selector_button.add_item('Dealers Choice', id_for_random)
	p1_deck_selector_button.select(id_for_random)
	p2_deck_selector_button.select(id_for_random)


func _on_start_match_button_pressed() -> void:
	var p1_ai_controller: AIController
	var p2_ai_controller: AIController

	var p1_name = "Player1"
	var p1_selected_id = p1_deck_selector_button.get_selected_id()
	var p1_deck: Deck
	if p1_selected_id == id_for_random:
		p1_deck = deck_list.pick_random()
	else:
		p1_deck = deck_list[p1_selected_id]

		
	var p2_name = "Player2"
	var p2_selected_id = p2_deck_selector_button.get_selected_id()
	var p2_deck: Deck
	if p2_selected_id == id_for_random:
		p2_deck = deck_list.pick_random()
	else:
		p2_deck = deck_list[p2_selected_id]
		
	p2_ai_controller = AIController.new()
	

	view_controller.change_to_combat_scene_multiplayer_hotseat(
		p1_name,
		p2_name,
		p1_deck,
		p2_deck,
		p1_ai_controller,
		p2_ai_controller,
	)
	

func _on_back_button_pressed() -> void:
	queue_free()
	
