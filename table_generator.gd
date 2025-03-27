class_name TableGenerator
extends Node


'''
1) Generate the structure of events, array, array[array], etc.  How many events and in what structure
2) Generate which events are what type
3) Populate/setup each event based on its type
'''

const PLACEMENT_RANDOMNESS := 5
const LENGTH := 10
const MONSTER_ROOM_WEIGHT := 12.0
const EVENT_ROOM_WEIGHT := 5.0
const SHOP_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0

#@export var battle_stats_pool: BattleStatsPool
#@export var event_room_pool: EventRoomPool

var random_room_type_weights = {
	StoryEvent.Type.MONSTER: 0.0,
	StoryEvent.Type.CAMPFIRE: 0.0,
	StoryEvent.Type.SHOP: 0.0,
	StoryEvent.Type.EVENT: 0.0
}
var random_room_type_total_weight := 0
var table_data: Array[StoryEvent]


func generate_table() -> Array[StoryEvent]:
	table_data = _generate_initial_spread()
	
	_setup_random_event_weights()
	_setup_event_types()
	_setup_event_based_on_type()
	
	return table_data


func _generate_initial_spread() -> Array[StoryEvent]:
	var result: Array[StoryEvent] = []
	
	for i in range(LENGTH):
		var event = StoryEvent.new()
		result.append(event)

	return result
	

func _setup_random_event_weights() -> void:
	random_room_type_weights[StoryEvent.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	random_room_type_weights[StoryEvent.Type.CAMPFIRE] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT
	random_room_type_weights[StoryEvent.Type.SHOP] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT + SHOP_ROOM_WEIGHT
	random_room_type_weights[StoryEvent.Type.EVENT] = random_room_type_weights[StoryEvent.Type.SHOP] + EVENT_ROOM_WEIGHT
	
	random_room_type_total_weight = random_room_type_weights[StoryEvent.Type.EVENT]


func _setup_event_types() -> void:
	for event: StoryEvent in table_data:
		event.type = StoryEvent.Type.MONSTER
		
		
func _setup_event_based_on_type() -> void:
	for event: StoryEvent in table_data:
		match event.type:
			StoryEvent.Type.MONSTER:
				var combat_stats = CombatStats.new()
				combat_stats.opp_temperament = _generate_opponent_temperament()
				combat_stats.opp_stats = _generate_opponent_stats_from_combat_stats(combat_stats)
				event.combat_stats = combat_stats
				


func _generate_opponent_temperament() -> int:
	return AIController.Temperament.values().pick_random()
	
			
func _generate_opponent_stats_from_combat_stats(combat_stats: CombatStats) -> Stats:
	var opp_stats = Stats.new()
	return opp_stats
	
	
	# first floor is always a battle
	#for event: StoryEvent in table_data[0]:
		#if room.next_rooms.size() > 0:
				#room.type = Room.Type.MONSTER
				#room.battle_stats = battle_stats_pool.get_random_battle_for_tier(0)
#
	## 9th floor is always a treasure
	#for room: Room in table_data[8]:
		#if room.next_rooms.size() > 0:
				#room.type = Room.Type.TREASURE
				#
	## last floor before the boss is always a campfire
	#for room: Room in table_data[13]:
		#if room.next_rooms.size() > 0:
				#room.type = Room.Type.CAMPFIRE
	#
	## rest of rooms
	#for current_floor in table_data:
		#for room: Room in current_floor:
			#for next_room: Room in room.next_rooms:
				#if next_room.type == Room.Type.NOT_ASSIGNED:
					#_set_room_randomly(next_room)


#func _set_room_randomly(room_to_set: Room) -> void:
	#var campfire_below_4 := true
	#var consecutive_campfire := true
	#var consecutive_shop := true
	#var campfire_on_13 := true
	#
	#var type_candidate: Room.Type
	#
	#while campfire_below_4 or consecutive_campfire or consecutive_shop or campfire_on_13:
		#type_candidate = _get_random_room_type_by_weight()
		#
		#var is_campfire := type_candidate == Room.Type.CAMPFIRE
		#var has_campfire_parent := _room_has_parent_of_type(room_to_set, Room.Type.CAMPFIRE)
		#var is_shop := type_candidate == Room.Type.SHOP
		#var has_shop_parent := _room_has_parent_of_type(room_to_set, Room.Type.SHOP)
		#
		#campfire_below_4 = is_campfire and room_to_set.row < 3
		#consecutive_campfire = is_campfire and has_campfire_parent
		#consecutive_shop = is_shop and has_shop_parent
		#campfire_on_13 = is_campfire and room_to_set.row == 12
		#
	#room_to_set.type = type_candidate
#
	#if type_candidate == Room.Type.MONSTER:
		#var tier_for_monster_rooms := 0
		#
		#if room_to_set.row > 2:
			#tier_for_monster_rooms = 1
			#
		#room_to_set.battle_stats = battle_stats_pool.get_random_battle_for_tier(tier_for_monster_rooms)
	#
	#if type_candidate == Room.Type.EVENT:
		#room_to_set.event_scene = event_room_pool.get_random()
#
#
#func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	#var parents: Array[Room] = []
	## left parent
	#if room.column > 0 and room.row > 0:
		#var parent_candidate := table_data[room.row - 1][room.column - 1] as Room
		#if parent_candidate.next_rooms.has(room):
			#parents.append(parent_candidate)
	## parent below
	#if room.row > 0:
		#var parent_candidate := table_data[room.row - 1][room.column] as Room
		#if parent_candidate.next_rooms.has(room):
			#parents.append(parent_candidate)
	## right parent
	#if room.column < table_WIDTH-1 and room.row > 0:
		#var parent_candidate := table_data[room.row - 1][room.column + 1] as Room
		#if parent_candidate.next_rooms.has(room):
			#parents.append(parent_candidate)
	#
	#for parent: Room in parents:
		#if parent.type == type:
			#return true
	#
	#return false
#
#
#func _get_random_room_type_by_weight() -> Room.Type:
	#var roll := randf_range(0.0, random_room_type_total_weight)
	#
	#for type: Room.Type in random_room_type_weights:
		#if random_room_type_weights[type] > roll:
			#return type
	#
	#return Room.Type.MONSTER
