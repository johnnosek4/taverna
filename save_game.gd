class_name SaveGame
extends Resource

const SAVE_PATH := "user://savegame.tres"

@export var rng_seed: int
@export var rng_state: int
@export var run_stats: RunStats
@export var char_stats: Stats
@export var current_health: int
@export var table_data: Array[StoryEvent]
@export var last_story_event: int
@export var was_on_map: bool
#@export var relics: Array[Relic]
#@export var floors_climbed: int


func save_data() -> void:
	var err := ResourceSaver.save(self, SAVE_PATH)
	assert(err == OK, "Couldn't save the game!")


static func load_data() -> SaveGame:
	if FileAccess.file_exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH) as SaveGame
	
	return null


static func delete_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
