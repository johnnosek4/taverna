class_name Run
extends Node

const COMBAT_SCENE := preload("res://combat_scene.tscn")
#const BATTLE_REWARD_SCENE := preload("res://scenes/battle_reward/battle_reward.tscn")
#const CAMPFIRE_SCENE := preload("res://scenes/campfire/campfire.tscn")
#const SHOP_SCENE := preload("res://scenes/shop/shop.tscn")
#const TREASURE_SCENE = preload("res://scenes/treasure/treasure.tscn")
#const WIN_SCREEN_SCENE := preload("res://scenes/win_screen/win_screen.tscn")
const MAIN_MENU_PATH := "res://ui/menus/main_menu.tscn"

@export var run_startup: RunStartup

@onready var table: Table = %Table
@onready var current_view: Node = %CurrentView
@onready var pause_menu: PauseMenu = %PauseMenu

#@onready var health_ui: HealthUI = %HealthUI
#@onready var gold_ui: GoldUI = %GoldUI
#@onready var relic_handler: RelicHandler = %RelicHandler
#@onready var relic_tooltip: RelicTooltip = %RelicTooltip
#@onready var deck_button: CardPileOpener = %DeckButton
#@onready var deck_view: CardPileView = %DeckView
#@onready var pause_menu: PauseMenu = $PauseMenu

#@onready var battle_button: Button = %BattleButton
#@onready var campfire_button: Button = %CampfireButton
#@onready var map_button: Button = %MapButton
#@onready var rewards_button: Button = %RewardsButton
#@onready var shop_button: Button = %ShopButton
#@onready var treasure_button: Button = %TreasureButton

var run_stats: RunStats
var character_stats: Stats
var save_data: SaveGame
var card_database: CardDatabase = CardDatabase.new()
var is_single_roll: bool = true #TODO incorporate into game settings and save/load


func _ready() -> void:
	if not run_startup:
		return
		
	card_database.init_all_cards() #NOTE: this is a hack since right now we're not passing in the card db
	
	pause_menu.save_and_quit.connect(
		func(): 
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
	)
	
	table.table_exited.connect(_on_table_exited)
	
	# NOTE: this is a hack while trying to figure out why deck resource wont work
	var warrior_deck = load("res://warrior_starting_deck.tres") #as Deck
	print('WARRIOR DECK: ', warrior_deck)
	run_startup.selected_character.starting_deck = warrior_deck
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character_stats = run_startup.selected_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			_load_run()


func _start_run() -> void:
	run_stats = RunStats.new()
	
	#_setup_event_connections()
	#_setup_top_bar()
	
	table.generate_new_table()
	#map.unlock_floor(0)
	
	save_data = SaveGame.new()
	_save_run(true)


func _save_run(was_on_map: bool) -> void:
	save_data.rng_seed = RNG.instance.seed
	save_data.rng_state = RNG.instance.state
	save_data.run_stats = run_stats
	save_data.char_stats = character_stats
	save_data.last_story_event = table.last_story_event
	save_data.cur_story_card_idx = table.cur_story_card_idx
	save_data.table_data = table.table_data.duplicate() #TODO: doesn't this need to be deep copy/ maybe even custom?
	save_data.was_on_map = was_on_map
	save_data.save_data()
	#save_data.floors_climbed = map.floors_climbed
	#save_data.current_deck = character.deck
	#save_data.current_health = character.health
	#save_data.relics = relic_handler.get_all_relics()


func _load_run() -> void:
	save_data = SaveGame.load_data()
	assert(save_data, "Couldn't load last save")
	
	RNG.set_from_save_data(save_data.rng_seed, save_data.rng_state)
	run_stats = save_data.run_stats
	character_stats = save_data.char_stats
	#character.deck = save_data.current_deck
	#character.health = save_data.current_health
	#relic_handler.add_relics(save_data.relics)
	#_setup_top_bar()
	#_setup_event_connections()
	
	table.load_table(save_data.table_data, save_data.last_story_event, save_data.cur_story_card_idx)
	if save_data.last_story_event and not save_data.was_on_map:
		_on_table_exited(save_data.last_story_event)


func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	table.hide_table()
	
	return new_view


func _show_table() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	table.show_table()
	#map.unlock_next_StoryEvents()
	
	_save_run(true)


#func _setup_event_connections() -> void:
	#Events.battle_won.connect(_on_battle_won)
	#Events.battle_reward_exited.connect(_show_map)
	#Events.campfire_exited.connect(_show_map)
	#Events.map_exited.connect(_on_map_exited)
	#Events.shop_exited.connect(_show_map)
	#Events.treasure_StoryEvent_exited.connect(_on_treasure_StoryEvent_exited)
	#Events.event_StoryEvent_exited.connect(_show_map)
	
	#battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	#campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	#map_button.pressed.connect(_show_map)
	#rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	#shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	#treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))


#func _setup_top_bar():
	#character.stats_changed.connect(health_ui.update_stats.bind(character))
	#health_ui.update_stats(character)
	#gold_ui.run_stats = stats
	#
	#relic_handler.add_relic(character.starting_relic)
	#Events.relic_tooltip_requested.connect(relic_tooltip.show_tooltip)
	#
	#deck_button.card_pile = character.deck
	#deck_view.card_pile = character.deck
	#deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))


func _show_regular_battle_rewards() -> void:
	print("Show Battle Reward Scene")
	_show_table()
	#var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	#reward_scene.run_stats = stats
	#reward_scene.character_stats = character
#
	#reward_scene.add_gold_reward(map.last_StoryEvent.battle_stats.roll_gold_reward())
	#reward_scene.add_card_reward()


func _on_combat_story_event_entered(story_event: StoryEvent) -> void:
	var combat_scene: CombatScene = _change_view(COMBAT_SCENE) as CombatScene
	combat_scene.p1_stats = character_stats
	combat_scene.p2_stats = story_event.combat_stats.opp_stats
	var opp_ai = AIController.new()
	opp_ai._temperament = story_event.combat_stats.opp_temperament
	combat_scene.p2_ai_controller = opp_ai
	combat_scene.card_database = card_database
	combat_scene.is_single_roll = is_single_roll
	combat_scene.combat_ended.connect(_on_combat_ended)
	combat_scene.initialize()
	combat_scene.start_combat()


func _on_treasure_story_event_entered() -> void:
	pass
	#var treasure_scene := _change_view(TREASURE_SCENE) as Treasure
	#treasure_scene.relic_handler = relic_handler
	#treasure_scene.char_stats = character
	#treasure_scene.generate_relic()


#func _on_treasure_story_event_exited(relic: Relic) -> void:
	#pass
	#var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	#reward_scene.run_stats = stats
	#reward_scene.character_stats = character
	#reward_scene.relic_handler = relic_handler
	#
	#reward_scene.add_relic_reward(relic)


func _on_campfire_entered() -> void:
	pass
	#var campfire := _change_view(CAMPFIRE_SCENE) as Campfire
	#campfire.char_stats = character


func _on_shop_entered() -> void:
	pass
	#var shop := _change_view(SHOP_SCENE) as Shop
	#shop.char_stats = character
	#shop.run_stats = stats
	#shop.relic_handler = relic_handler
	#Events.shop_entered.emit(shop)
	#shop.populate_shop()


func _on_event_story_event_entered(story_event: StoryEvent) -> void:
	pass
	#var event_story_event := _change_view(story_event.event_scene) #as EventStoryEvent
	#event_story_event.character_stats = character
	#event_story_event.run_stats = stats
	#event_story_event.setup()


func _on_combat_ended(stats_of_dead_player: Stats) -> void:
	print('on_combat_ended')
	print('stats_of_dead_player.name: ',stats_of_dead_player.name)
	print('character_stats.name: ',character_stats.name)

	if not stats_of_dead_player.name == character_stats.name:
		if table.cur_story_card_idx + 1 == TableGenerator.LENGTH:
			print('Player is Victorious')
			SaveGame.delete_data()
		else:
			_show_regular_battle_rewards()
	else:
		print('Player is DEAD')


func _on_table_exited(story_event: StoryEvent) -> void:
	_save_run(false)
	
	match story_event.type:
		StoryEvent.Type.MONSTER:
			_on_combat_story_event_entered(story_event)
		StoryEvent.Type.TREASURE:
			_on_treasure_story_event_entered()
		StoryEvent.Type.CAMPFIRE:
			_on_campfire_entered()
		StoryEvent.Type.SHOP:
			_on_shop_entered()
		StoryEvent.Type.BOSS:
			_on_combat_story_event_entered(story_event)
		StoryEvent.Type.EVENT:
			_on_event_story_event_entered(story_event)



#class_name Run
#extends Node
#
#const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
#const BATTLE_REWARD_SCENE := preload("res://scenes/battle_reward/battle_reward.tscn")
#const CAMPFIRE_SCENE := preload("res://scenes/campfire/campfire.tscn")
#const SHOP_SCENE := preload("res://scenes/shop/shop.tscn")
#const TREASURE_SCENE = preload("res://scenes/treasure/treasure.tscn")
#const WIN_SCREEN_SCENE := preload("res://scenes/win_screen/win_screen.tscn")
#const MAIN_MENU_PATH := "res://scenes/ui/main_menu.tscn"
#
#@export var run_startup: RunStartup
#
#@onready var map: Map = $Map
#@onready var current_view: Node = $CurrentView
#@onready var health_ui: HealthUI = %HealthUI
#@onready var gold_ui: GoldUI = %GoldUI
#@onready var relic_handler: RelicHandler = %RelicHandler
#@onready var relic_tooltip: RelicTooltip = %RelicTooltip
#@onready var deck_button: CardPileOpener = %DeckButton
#@onready var deck_view: CardPileView = %DeckView
#@onready var pause_menu: PauseMenu = $PauseMenu
#
#@onready var battle_button: Button = %BattleButton
#@onready var campfire_button: Button = %CampfireButton
#@onready var map_button: Button = %MapButton
#@onready var rewards_button: Button = %RewardsButton
#@onready var shop_button: Button = %ShopButton
#@onready var treasure_button: Button = %TreasureButton
#
#var stats: RunStats
#var character: CharacterStats
#var save_data: SaveGame
#
#
#func _ready() -> void:
	#if not run_startup:
		#return
	#
	#pause_menu.save_and_quit.connect(
		#func(): 
			#get_tree().change_scene_to_file(MAIN_MENU_PATH)
	#)
	#
	#match run_startup.type:
		#RunStartup.Type.NEW_RUN:
			#character = run_startup.picked_character.create_instance()
			#_start_run()
		#RunStartup.Type.CONTINUED_RUN:
			#_load_run()
#
#
#func _start_run() -> void:
	#stats = RunStats.new()
	#
	#_setup_event_connections()
	#_setup_top_bar()
	#
	#map.generate_new_map()
	#map.unlock_floor(0)
	#
	#save_data = SaveGame.new()
	#_save_run(true)
#
#
#func _save_run(was_on_map: bool) -> void:
	#save_data.rng_seed = RNG.instance.seed
	#save_data.rng_state = RNG.instance.state
	#save_data.run_stats = stats
	#save_data.char_stats = character
	#save_data.current_deck = character.deck
	#save_data.current_health = character.health
	#save_data.relics = relic_handler.get_all_relics()
	#save_data.last_StoryEvent = map.last_StoryEvent
	#save_data.map_data = map.map_data.duplicate()
	#save_data.floors_climbed = map.floors_climbed
	#save_data.was_on_map = was_on_map
	#save_data.save_data()
#
#
#func _load_run() -> void:
	#save_data = SaveGame.load_data()
	#assert(save_data, "Couldn't load last save")
	#
	#RNG.set_from_save_data(save_data.rng_seed, save_data.rng_state)
	#stats = save_data.run_stats
	#character = save_data.char_stats
	#character.deck = save_data.current_deck
	#character.health = save_data.current_health
	#relic_handler.add_relics(save_data.relics)
	#_setup_top_bar()
	#_setup_event_connections()
	#
	#map.load_map(save_data.map_data, save_data.floors_climbed, save_data.last_StoryEvent)
	#if save_data.last_StoryEvent and not save_data.was_on_map:
		#_on_map_exited(save_data.last_StoryEvent)
#
#
#func _change_view(scene: PackedScene) -> Node:
	#if current_view.get_child_count() > 0:
		#current_view.get_child(0).queue_free()
	#
	#get_tree().paused = false
	#var new_view := scene.instantiate()
	#current_view.add_child(new_view)
	#map.hide_map()
	#
	#return new_view
#
#
#func _show_map() -> void:
	#if current_view.get_child_count() > 0:
		#current_view.get_child(0).queue_free()
#
	#map.show_map()
	#map.unlock_next_StoryEvents()
	#
	#_save_run(true)
#
#
#func _setup_event_connections() -> void:
	#Events.battle_won.connect(_on_battle_won)
	#Events.battle_reward_exited.connect(_show_map)
	#Events.campfire_exited.connect(_show_map)
	#Events.map_exited.connect(_on_map_exited)
	#Events.shop_exited.connect(_show_map)
	#Events.treasure_StoryEvent_exited.connect(_on_treasure_StoryEvent_exited)
	#Events.event_StoryEvent_exited.connect(_show_map)
	#
	#battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	#campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	#map_button.pressed.connect(_show_map)
	#rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	#shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	#treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))
#
#
#func _setup_top_bar():
	#character.stats_changed.connect(health_ui.update_stats.bind(character))
	#health_ui.update_stats(character)
	#gold_ui.run_stats = stats
	#
	#relic_handler.add_relic(character.starting_relic)
	#Events.relic_tooltip_requested.connect(relic_tooltip.show_tooltip)
	#
	#deck_button.card_pile = character.deck
	#deck_view.card_pile = character.deck
	#deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))
#
#
#func _show_regular_battle_rewards() -> void:
	#var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	#reward_scene.run_stats = stats
	#reward_scene.character_stats = character
#
	#reward_scene.add_gold_reward(map.last_StoryEvent.battle_stats.roll_gold_reward())
	#reward_scene.add_card_reward()
#
#
#func _on_battle_StoryEvent_entered(StoryEvent: StoryEvent) -> void:
	#var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	#battle_scene.char_stats = character
	#battle_scene.battle_stats = StoryEvent.battle_stats
	#battle_scene.relics = relic_handler
	#battle_scene.start_battle()
#
#
#func _on_treasure_StoryEvent_entered() -> void:
	#var treasure_scene := _change_view(TREASURE_SCENE) as Treasure
	#treasure_scene.relic_handler = relic_handler
	#treasure_scene.char_stats = character
	#treasure_scene.generate_relic()
#
#
#func _on_treasure_StoryEvent_exited(relic: Relic) -> void:
	#var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	#reward_scene.run_stats = stats
	#reward_scene.character_stats = character
	#reward_scene.relic_handler = relic_handler
	#
	#reward_scene.add_relic_reward(relic)
#
#
#func _on_campfire_entered() -> void:
	#var campfire := _change_view(CAMPFIRE_SCENE) as Campfire
	#campfire.char_stats = character
#
#
#func _on_shop_entered() -> void:
	#var shop := _change_view(SHOP_SCENE) as Shop
	#shop.char_stats = character
	#shop.run_stats = stats
	#shop.relic_handler = relic_handler
	#Events.shop_entered.emit(shop)
	#shop.populate_shop()
#
#
#func _on_event_StoryEvent_entered(StoryEvent: StoryEvent) -> void:
	#var event_StoryEvent := _change_view(StoryEvent.event_scene) as EventStoryEvent
	#event_StoryEvent.character_stats = character
	#event_StoryEvent.run_stats = stats
	#event_StoryEvent.setup()
#
#
#func _on_battle_won() -> void:
	#if map.floors_climbed == MapGenerator.FLOORS:
		#var win_screen := _change_view(WIN_SCREEN_SCENE) as WinScreen
		#win_screen.character = character
		#SaveGame.delete_data()
	#else:
		#_show_regular_battle_rewards()
#
#
#func _on_map_exited(StoryEvent: StoryEvent) -> void:
	#_save_run(false)
	#
	#match StoryEvent.type:
		#StoryEvent.Type.MONSTER:
			#_on_battle_StoryEvent_entered(StoryEvent)
		#StoryEvent.Type.TREASURE:
			#_on_treasure_StoryEvent_entered()
		#StoryEvent.Type.CAMPFIRE:
			#_on_campfire_entered()
		#StoryEvent.Type.SHOP:
			#_on_shop_entered()
		#StoryEvent.Type.BOSS:
			#_on_battle_StoryEvent_entered(StoryEvent)
		#StoryEvent.Type.EVENT:
			#_on_event_StoryEvent_entered(StoryEvent)
