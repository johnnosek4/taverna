class_name StoryEventCard
extends Control

signal story_event_selected(event: StoryEvent)

var story_event: StoryEvent
var face_down: bool: set = set_face_down
var selectable: bool = false
var tween: Tween

@onready var event_name_label: Label = %EventNameLabel
@onready var event_type_label: Label = %EventTypeLabel
@onready var card_back: ColorRect = %CardBack


func _ready() -> void:
	_populate_card()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func set_face_down(value: bool) -> void:
	face_down = value
	if face_down:
		card_back.show()
	else:
		card_back.hide()


func _populate_card() -> void:
	event_name_label.text = story_event.get_event_name()
	event_type_label.text = story_event.get_type_as_str()
	

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if face_down:
			print('Card Clicked and face down')
			face_down = false
		else:
			print('Story Event Pressed at Card')
			story_event_selected.emit(story_event)
		print('End of input event action')

func _on_mouse_entered() -> void:
	print('on mouse entered')
	if selectable:
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.2).set_trans(Tween.TRANS_BOUNCE)
		print('SELECTABLE')
		card_back.color = Color.AQUAMARINE


func _on_mouse_exited() -> void:
	print('on mouse exited')
	if selectable:
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.2).set_trans(Tween.TRANS_BOUNCE)

		print('SELECTABLE')
		card_back.color = Color('2c6a28')
