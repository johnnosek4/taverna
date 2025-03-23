class_name ViewController
extends Node


const COMBAT_SCENE = preload("res://combat_scene.tscn")
const DECK_BUILDER_SCENE = preload("res://ui/menus/deck/deck_builder_ui.tscn")
const COLLECTION_SCENE = preload("res://card_collection_ui/collection_view.tscn")
const DECK_MANAGER_SCENE = preload("res://deck_manager.tscn")
const MAIN_MENU = preload("res://ui/menus/main_menu.tscn")

@onready var current_view: Node = %CurrentView
@onready var card_database: CardDatabase = %CardDatabase



func change_to_combat_scene_multiplayer_hotseat(
	p1_name: String,
	p2_name: String,
	p1_deck: Deck,
	p2_deck: Deck,
) -> void:
	var combat_scene = _change_view(COMBAT_SCENE) as CombatScene
	
	var p1_stats = Stats.new()
	p1_stats.name = p1_name
	p1_stats.deck = p1_deck
		
	var p2_stats = Stats.new()
	p2_stats.name = p2_name
	p2_stats.deck = p2_deck

	#TODO: move these into the initialize so its explicit
	#also - rename the initialize? since this happens wayy after init, and node is already added
	combat_scene.p1_stats = p1_stats
	combat_scene.p2_stats = p2_stats
	combat_scene.card_database = card_database
	combat_scene.initialize()
	combat_scene.start_combat()


#TODO: 
# update this and pass in card database reference
# also, need to load player collection and pass into collection view too
#func _on_combat_menu_deck_view_button_pressed() -> void:
	#var deck_manager_scene = _change_view(DECK_MANAGER_SCENE) as DeckManager
	#deck_manager_scene.player_collection = cur_player_collection
	#deck_manager_scene.card_database = card_database
	#deck_manager_scene.complete_setup()
	
	#var deck_builder_scene = _change_view(DECK_BUILDER_SCENE) as DeckBuilderUI
	#deck_builder_scene.stats = p1_stats
	#deck_builder_scene.generate_card_views()
	

#func _on_combat_menu_p2_deck_view_button_pressed() -> void:
	#var deck_builder_scene = _change_view(DECK_BUILDER_SCENE) as DeckBuilderUI
	#deck_builder_scene.stats = p2_stats
	#deck_builder_scene.generate_card_views()
	

#func _on_combat_menu_pvp_button_pressed() -> void:
	#var sp_combat_scene = _change_view(COMBAT_SCENE) as CombatScene
	#p2_stats.player_type = Stats.PlayerType.HUMAN
	#sp_combat_scene.card_database = card_database
	#sp_combat_scene.p1_stats = p1_stats
	#sp_combat_scene.p2_stats = p2_stats
	#sp_combat_scene.initialize()
	#sp_combat_scene.start_combat()


func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)

	return new_view
