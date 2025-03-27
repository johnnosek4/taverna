class_name Table
extends Node2D

'''
This is basically the table of slay
It will show the layout of event cards as you progress through them
'''

@onready var table_generator: TableGenerator = %TableGenerator
@onready var table_ui: TableUI = %TableUI

var last_event: int = 7
var table_data: Array[StoryEvent]


func _ready() -> void:
	table_ui.story_event_selected.connect(_on_story_event_selected)
	generate_new_table()


func generate_new_table() -> void:
	table_data = table_generator.generate_table()
	create_table()


func load_table(table: Array[StoryEvent], last_event_completed: int) -> void:
	table_data = table
	last_event = last_event_completed
	create_table()


func create_table() -> void:
	var idx: int = 0
	for event in table_data:
		if idx <= last_event:
			table_ui.add_story_event_card(event)
		elif idx == last_event + 1:
			table_ui.add_story_event_card_down(event, true)
		else:
			table_ui.add_story_event_card_down(event, false)

		idx += 1


func _on_story_event_selected(event: StoryEvent) -> void:
	pass
	#last_room = room
	#floors_climbed += 1
	#Events.map_exited.emit(room)
