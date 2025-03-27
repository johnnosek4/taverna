class_name StoryEventCard
extends Control

var story_event: StoryEvent

@onready var event_name_label: Label = %EventNameLabel
@onready var event_type_label: Label = %EventTypeLabel


func _ready() -> void:
	_populate_card()
	
	
func _populate_card() -> void:
	event_name_label.text = story_event.get_event_name()
	event_type_label.text = story_event.get_type_as_str()
