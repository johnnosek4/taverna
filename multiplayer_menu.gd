class_name MultiplayerMenu
extends Control


const DECK_MANAGER_SCENE = preload("res://deck_manager.tscn")
const HOTSEAT_MENU_SCENE = preload("res://ui/menus/hotseat_menu.tscn")
#const COLLECTION_SCENE = preload("res://card_collection_ui/collection_view.tscn")

@onready var back_button: Button = %BackButton
@onready var deck_builder_button: Button = %DeckBuilderButton
@onready var hotseat_button: Button = %HotseatButton
@onready var online_button: Button = %OnlineButton

var player_collection: PlayerCollection
var card_database: CardDatabase
var view_controller: ViewController


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	deck_builder_button.pressed.connect(_on_deck_builder_button_pressed)
	hotseat_button.pressed.connect(_on_hotseat_button_pressed)
	online_button.pressed.connect(_on_online_button_pressed)


func _on_hotseat_button_pressed() -> void:
	var hotseat_menu_scene = HOTSEAT_MENU_SCENE.instantiate() as HotseatMenu
	hotseat_menu_scene.player_collection = player_collection
	hotseat_menu_scene.view_controller = view_controller
	add_child(hotseat_menu_scene)



func _on_deck_builder_button_pressed() -> void:
	var deck_manager_scene = DECK_MANAGER_SCENE.instantiate() as DeckManager
	add_child(deck_manager_scene)
	deck_manager_scene.player_collection = player_collection
	deck_manager_scene.card_database = card_database
	deck_manager_scene.complete_setup()


func _on_online_button_pressed() -> void:
	print('ONLINE_BUTTON_PRESSED')
	
func _on_back_button_pressed() -> void:
	queue_free()
