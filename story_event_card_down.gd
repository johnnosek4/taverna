class_name StoryEventCardDown
extends Control

signal story_event_selected(event: StoryEvent)

var story_event = StoryEvent
var selectable: bool = false

@onready var card_back: ColorRect = %CardBack


func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print('Story Event Pressed at Card')
		story_event_selected.emit(story_event)


func _on_mouse_entered() -> void:
	print('on mouse entered')
	if selectable:
		print('SELECTABLE')
		card_back.color = Color.AQUAMARINE


func _on_mouse_exited() -> void:
	print('on mouse exited')
	if selectable:
		print('SELECTABLE')
		card_back.color = Color('424288')
	
