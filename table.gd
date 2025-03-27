class_name Table
extends Node2D

signal table_exited(event: StoryEvent)

'''
This is basically the table of slay
It will show the layout of event cards as you progress through them
'''

@onready var table_generator: TableGenerator = %TableGenerator
@onready var table_ui: TableUI = %TableUI

var cur_story_card_idx: int = 0
var last_story_event: StoryEvent
var table_data: Array[StoryEvent]


func _ready() -> void:
	table_ui.story_event_selected.connect(_on_story_event_selected)
	#generate_new_table()


func generate_new_table() -> void:
	table_data = table_generator.generate_table()
	create_table()


func load_table(table: Array[StoryEvent], event_completed: StoryEvent, story_card_idx: int) -> void:
	table_data = table
	last_story_event = event_completed
	cur_story_card_idx = story_card_idx
	create_table()


func show_table() -> void:
	show()
	#camera_2d.enabled = true


func hide_table() -> void:
	hide()
	#NOTE: originally some camera 2d stuff


func create_table() -> void:
	table_ui.clear_event_cards()
	print('CREATE TABLE CALLED')
	var idx: int = 0
	for event in table_data:
		if idx < cur_story_card_idx:
			table_ui.add_story_event_card(event, false, false)
		elif idx == cur_story_card_idx:
			if event == last_story_event:
				table_ui.add_story_event_card(event, false, true)
			else:
				table_ui.add_story_event_card(event, true, true)
		else:
			table_ui.add_story_event_card(event, true, false)

		idx += 1


func _on_story_event_selected(event: StoryEvent) -> void:
	last_story_event = event
	cur_story_card_idx += 1
	table_exited.emit(event)
	create_table()
	#last_room = room
	#floors_climbed += 1
	#Events.map_exited.emit(room)
