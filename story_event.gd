class_name StoryEvent
extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, BOSS, EVENT}

@export var type: Type
# This is only used by the MONSTER and BOSS types
@export var combat_stats: CombatStats
# This is only used by the EVENT room type
@export var event_scene: PackedScene


func get_type_as_str() -> String:
	return Type.keys()[type]


func get_event_name() -> String:
	#TODO: if combat, get opponents name
	return "Floob"
	
	
#enum Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, BOSS, EVENT}
#
#@export var type: Type
#@export var row: int
#@export var column: int
#@export var position: Vector2
#@export var next_rooms: Array[Room]
#@export var selected := false
## This is only used by the MONSTER and BOSS types
#@export var battle_stats: BattleStats
## This is only used by the EVENT room type
#@export var event_scene: PackedScene
#
#
#func _to_string() -> String:
	#return "%s (%s)" % [column, Type.keys()[type][0]]
