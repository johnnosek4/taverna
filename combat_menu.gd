class_name MainMenu
extends ColorRect

const MATCH_MENU_SCENE = preload("res://match_menu.tscn")
const SINGLEPLAYER_MENU_SCENE = preload("res://singleplayer_menu.tscn")

@onready var story_button: Button = %StoryButton
@onready var match_button: Button = %MatchButton
@onready var options_button: Button = %OptionsButton
@onready var exit_button: Button = %ExitButton

var player_collection: PlayerCollection
var card_database: CardDatabase
var view_controller: ViewController


func _ready() -> void:
	exit_button.pressed.connect(_on_exit_button_pressed)
	story_button.pressed.connect(_on_story_button_pressed)
	match_button.pressed.connect(_on_match_button_pressed)



func _on_match_button_pressed() -> void:
	var match_menu = MATCH_MENU_SCENE.instantiate() as MatchMenu
	match_menu.player_collection = player_collection
	match_menu.card_database = card_database
	match_menu.view_controller = view_controller
	add_child(match_menu)


func _on_story_button_pressed() -> void:
	pass
	#var singleplayer_menu = SINGLEPLAYER_MENU_SCENE.instantiate() as SingleplayerMenu
	#singleplayer_menu.player_collection = player_collection
	#singleplayer_menu.card_database = card_database
	#singleplayer_menu.view_controller = view_controller
	#add_child(singleplayer_menu)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
	
