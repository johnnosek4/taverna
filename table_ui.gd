class_name TableUI
extends Control

signal story_event_selected(event: StoryEvent)

const STORY_EVENT_CARD_SCENE = preload("res://story_event_card.tscn")
const STORY_EVENT_CARD_DOWN_SCENE = preload("res://story_event_card_down.tscn")

@onready var card_container: HFlowContainer = %CardContainer


func clear_event_cards() -> void:
	for child in card_container.get_children():
		child.queue_free()


func add_story_event_card(story_event: StoryEvent, face_down: bool, selectable: bool = false) -> void:
	var story_event_card = STORY_EVENT_CARD_SCENE.instantiate() as StoryEventCard
	story_event_card.story_event = story_event
	card_container.add_child(story_event_card)
	story_event_card.face_down = face_down

	
	if selectable:
		story_event_card.selectable = true
		story_event_card.story_event_selected.connect(_on_story_event_selected)
		


#func add_story_event_card_down(story_event: StoryEvent, ) -> void:
	#var story_event_card_down = STORY_EVENT_CARD_DOWN_SCENE.instantiate() as StoryEventCardDown
	#story_event_card_down.story_event = story_event
	#card_container.add_child(story_event_card_down)



func _on_story_event_selected(story_event: StoryEvent) -> void:
	print('ON STORY EVENT SELECTED: ', story_event.get_event_name())
	story_event_selected.emit(story_event)
