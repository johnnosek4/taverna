class_name MainMenu
extends ColorRect

const MULTIPLAYER_MENU_SCENE = preload("res://multiplayer_menu.tscn")

@onready var single_player_button: Button = %SinglePlayerButton
@onready var multiplayer_button: Button = %MultiplayerButton
@onready var options_button: Button = %OptionsButton
@onready var exit_button: Button = %ExitButton

var player_collection: PlayerCollection
var card_database: CardDatabase
var view_controller: ViewController


func _ready() -> void:
	exit_button.pressed.connect(_on_exit_button_pressed)
	multiplayer_button.pressed.connect(_on_multiplayer_button_pressed)


func _on_multiplayer_button_pressed() -> void:
	var multiplayer_menu = MULTIPLAYER_MENU_SCENE.instantiate() as MultiplayerMenu
	multiplayer_menu.player_collection = player_collection
	multiplayer_menu.card_database = card_database
	multiplayer_menu.view_controller = view_controller
	add_child(multiplayer_menu)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
	
