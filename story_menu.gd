class_name StoryMenu
extends Control


const CHAR_SELECTOR_MENU_SCENE := preload("res://ui/menus/character_selector_menu.tscn")
const RUN_SCENE = preload("res://run.tscn")

@export var run_startup: RunStartup

@onready var back_button: Button = %BackButton
@onready var continue_button: Button = %ContinueButton
@onready var new_story_button: Button = %NewStoryButton

var player_collection: PlayerCollection
var card_database: CardDatabase
var view_controller: ViewController


func _ready() -> void:
	get_tree().paused = false
	continue_button.disabled = SaveGame.load_data() == null
	back_button.pressed.connect(_on_back_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	new_story_button.pressed.connect(_on_new_story_button_pressed)


func _on_continue_button_pressed() -> void:
	run_startup.type = RunStartup.Type.CONTINUED_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_new_story_button_pressed() -> void:
	var char_selector_menu = CHAR_SELECTOR_MENU_SCENE.instantiate() as CharacterSelectorMenu
	add_child(char_selector_menu)
	#get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)

	
func _on_back_button_pressed() -> void:
	queue_free()
