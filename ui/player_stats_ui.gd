class_name PlayerStatsUI
extends Control

var stats: Stats

@onready var name_label = %NameLabel
@onready var health_label = %HealthLabel
@onready var effects_container = %EffectsContainer


func update() -> void:
	name_label.text = stats.name
	update_health_label(stats.current_health, stats.max_health)
	update_effects_container(stats.effects)


func update_health_label(current: int, max: int) -> void:
	health_label.text = str(current) + ' / ' + str(max)
	

func update_effects_container(effects: Dictionary) -> void:
	for child in effects_container.get_children():
		child.queue_free()
	for effect in effects:
		var new_label = Label.new()
		var counter = '' if effects[effect] == 0 else 'x ' + str(effects[effect])
		new_label.text = Stats.Effect.keys()[effect] + counter
		effects_container.add_child(new_label)
