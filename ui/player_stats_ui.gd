class_name PlayerStatsUI
extends Panel

var stats: Stats

@onready var name_label = %NameLabel
@onready var health_label = %HealthLabel
@onready var effects_container = %EffectsContainer
@onready var timer_label: Label = %TimerLabel


func update() -> void:
	name_label.text = stats.name
	update_health_label(stats.current_health, stats.max_health)
	update_effects_container(stats.effects)


func update_health_label(current: int, max_health: int) -> void:
	health_label.text = str(current) + ' / ' + str(max_health)
	

func update_effects_container(effects: Array[Effect]) -> void:
	for child in effects_container.get_children():
		child.queue_free()
	for effect in effects:
		var new_label = Label.new()
		
		new_label.text = effect.get_name() + ' ' + str(effect.duration) + 'x'
		new_label.add_theme_font_size_override('font_size', 36)
		effects_container.add_child(new_label)
