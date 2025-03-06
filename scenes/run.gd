class_name Run
extends Node


const COMBAT_SCENE = preload("res://combat_scene.tscn")
const DECK_BUILDER_SCENE = preload("res://ui/menus/deck/deck_builder_ui.tscn")

@onready var current_view: Node = %CurrentView
@onready var combat_menu: CombatMenu = %CombatMenu

var p1_stats: Stats
var p2_stats: Stats


func _ready() -> void:
	_generate_default_stats()
	combat_menu.single_player_button.pressed.connect(_on_combat_menu_single_player_button_pressed)
	combat_menu.p1_deck_view_button.pressed.connect(_on_combat_menu_p1_deck_view_button_pressed)
	combat_menu.p2_deck_view_button.pressed.connect(_on_combat_menu_p2_deck_view_button_pressed)
	combat_menu.pvp_button.pressed.connect(_on_combat_menu_pvp_button_pressed)

func _on_combat_menu_single_player_button_pressed() -> void:
	var sp_combat_scene = _change_view(COMBAT_SCENE) as CombatScene
	sp_combat_scene.p1_stats = p1_stats
	sp_combat_scene.p2_stats = p2_stats
	sp_combat_scene.initialize()


func _on_combat_menu_p1_deck_view_button_pressed() -> void:
	var deck_builder_scene = _change_view(DECK_BUILDER_SCENE) as DeckBuilderUI
	deck_builder_scene.stats = p1_stats
	deck_builder_scene.generate_card_views()
	

func _on_combat_menu_p2_deck_view_button_pressed() -> void:
	var deck_builder_scene = _change_view(DECK_BUILDER_SCENE) as DeckBuilderUI
	deck_builder_scene.stats = p2_stats
	deck_builder_scene.generate_card_views()
	

func _on_combat_menu_pvp_button_pressed() -> void:
	var sp_combat_scene = _change_view(COMBAT_SCENE) as CombatScene
	p2_stats.player_type = Stats.PlayerType.HUMAN
	sp_combat_scene.p1_stats = p1_stats
	sp_combat_scene.p2_stats = p2_stats
	sp_combat_scene.initialize()


func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)

	return new_view


func _generate_default_stats() -> void:
	var strike = Strike.new()
	var lunge = Lunge.new()
	var guard = Guard.new()
	var flourish = Flourish.new()
	var feint = Feint.new()
	var disengage = Disengage.new()
	#var passage = Passage.new()
	var bash = Bash.new()
	var finisher = Finisher.new()
	var measured = Measured.new()
	
	p1_stats = Stats.new()
	p1_stats.card_pile = {
		strike: 1,
		lunge: 1,
		guard: 1,
		flourish: 1,
		feint: 1,
		disengage: 1,
		#passage: 1,
		bash: 1,
		finisher: 1,
		measured: 1
		}
		
	p2_stats = Stats.new()
	p2_stats.name = "Opponent"
	p2_stats.player_type = Stats.PlayerType.AI
	p2_stats.card_pile = {
		strike: 1,
		lunge: 1,
		guard: 1,
		flourish: 1,
		feint: 1,
		disengage: 1,
		#passage: 1,
		bash: 1,
		finisher: 1,
		measured: 1
		}
