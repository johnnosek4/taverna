class_name CharacterSelectorMenu
extends Control

const RUN_SCENE = preload("res://run.tscn")
#const ASSASSIN_STATS := preload("res://characters/assassin/assassin.tres")
#const WARRIOR_STATS := preload("res://characters/warrior/warrior.tres")
#const WIZARD_STATS := preload("res://characters/wizard/wizard.tres")

@export var run_startup: RunStartup

@onready var back_button: Button = %BackButton
@onready var p_1_name_line_edit: LineEdit = %P1NameLineEdit
@onready var start_button: Button = %StartButton


#@onready var title: Label = %Title
#@onready var description: Label = %Description
#@onready var character_portrait: TextureRect = %CharacterPortrait

var current_character: Stats : set = set_current_character


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	start_button.pressed.connect(_on_start_button_pressed)
	#set_current_character(WARRIOR_STATS)


func set_current_character(new_character: Stats) -> void:
	pass
	#current_character = new_character
	#title.text = current_character.character_name
	#description.text = current_character.description
	#character_portrait.texture = current_character.portrait


func _on_start_button_pressed() -> void:
	var current_character = Stats.new()
	current_character.name = p_1_name_line_edit.text
	print("Start new Run with %s" % current_character.name)
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.selected_character = current_character
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_back_button_pressed() -> void:
	queue_free()

#func _on_warrior_button_pressed() -> void:
	#current_character = WARRIOR_STATS
#
#
#func _on_wizard_button_pressed() -> void:
	#current_character = WIZARD_STATS
#
#
#func _on_assassin_button_pressed() -> void:
	#current_character = ASSASSIN_STATS
