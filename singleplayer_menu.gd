class_name SingleplayerMenu
extends Control


const MATCH_MENU_SCENE = preload("res://ui/menus/sp_match_menu.tscn")
#const COLLECTION_SCENE = preload("res://card_collection_ui/collection_view.tscn")

@onready var back_button: Button = %BackButton
@onready var story_button: Button = %StoryButton
@onready var match_button: Button = %MatchButton

var player_collection: PlayerCollection
var card_database: CardDatabase
var view_controller: ViewController


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	story_button.pressed.connect(_on_story_button_pressed)
	match_button.pressed.connect(_on_match_button_pressed)


func _on_story_button_pressed() -> void:
	print('story_button_PRESSED')


func _on_match_button_pressed() -> void:
	var sp_match_menu_scene = MATCH_MENU_SCENE.instantiate() as SPMatchMenu
	sp_match_menu_scene.player_collection = player_collection
	sp_match_menu_scene.view_controller = view_controller
	add_child(sp_match_menu_scene)


func _on_back_button_pressed() -> void:
	queue_free()
