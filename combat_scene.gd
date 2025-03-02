class_name CombatScene
extends Node2D

'''
for now we'll plan on p1 is a human player and p2 is an AI opponent
but as best we can, try and plan for PVP
'''

var p1_stats: Stats
var p2_stats: Stats
var p1_combat_cards_state: CombatCardState
var p2_combat_cards_state: CombatCardState
var p1_controller: PlayerController
var p2_controller: PlayerController
var current_player_turn: int = 1
var card_state_current_player: CombatCardState

const card_ui_scene = preload("res://ui/card_ui.tscn")
const end_menu_scene = preload("res://ui/menus/end_game_menu.tscn")

@onready var draw_button = %DrawButton
@onready var end_turn_button = %EndTurnButton
@onready var run_hbox = %RunHBox
@onready var player1_stats_ui = %Player1StatsUI
@onready var player2_stats_ui = %Player2StatsUI
@onready var combat_log = %CombatLog
@onready var menu_ui = %MenuUI
@onready var draw_pile_ui_p1 = %DrawPileUIP1


'''
contains the combat controller
'''

func _ready():
	test()
	card_state_current_player = p1_combat_cards_state
	draw_button.pressed.connect(draw_card.bind(card_state_current_player))
	end_turn_button.pressed.connect(close_run.bind(card_state_current_player))
	player1_stats_ui.stats = p1_stats
	player1_stats_ui.update()
	p1_stats.stats_changed.connect(player1_stats_ui.update)
	p1_stats.dead.connect(_on_death)
	player2_stats_ui.stats = p2_stats
	player2_stats_ui.update()
	p2_stats.stats_changed.connect(player2_stats_ui.update)
	p2_stats.dead.connect(_on_death)
	draw_pile_ui_p1.card_state = p1_combat_cards_state
	draw_pile_ui_p1.update()
	

func test() -> void:
	p1_stats = Stats.new()
	var card1 = Strike.new()
	var card2 = Strike.new()
	var card3 = Strike.new()
	var card4 = Lunge.new()
	p1_stats.card_pile = [card1, card4]
	p1_stats.deck = [card1, card2, card3, card4]
	p2_stats = Stats.new()
	p2_stats.name = "Opponent"
	p2_stats.card_pile = [card1]
	
	initialize_combat_state()

func set_player_turn() -> void:
	current_player_turn = 1
	
func prompt_player_turn() -> void:
	pass

func initialize_combat_state() -> void:
	p1_combat_cards_state = CombatCardState.new()
	p1_combat_cards_state.source_draw_pile = p1_stats.deck.duplicate(true)
	reshuffle_draw_pile(p1_combat_cards_state)
	
	p2_combat_cards_state = CombatCardState.new()
	p2_combat_cards_state.source_draw_pile = p2_stats.deck.duplicate(true)
	reshuffle_draw_pile(p2_combat_cards_state)


func get_card_state_noncurrent_player() -> CombatCardState:
	return p2_combat_cards_state if card_state_current_player == p1_combat_cards_state else p1_combat_cards_state

func get_stats_current_player() -> Stats:
	return p2_stats if card_state_current_player == p2_combat_cards_state else p1_stats

func get_stats_noncurrent_player() -> Stats:
	return p1_stats if card_state_current_player == p2_combat_cards_state else p2_stats

#could make these functional and return a copy of the card state, but not sure of performance impacts
func reshuffle_draw_pile(card_state: CombatCardState) -> void:
	card_state.draw_pile = card_state.source_draw_pile.duplicate(true)
	card_state.draw_pile.shuffle()


func draw_card(card_state: CombatCardState) -> void:
	if len(card_state.draw_pile) > 0:
		#Game Logic
		var drawn_card = card_state.draw_pile.pop_front()
		card_state.run.append(drawn_card)
		
		#UI Stuff
		var new_card_ui = card_ui_scene.instantiate()
		new_card_ui.card = drawn_card
		run_hbox.add_child(new_card_ui)
		combat_log.log_event('drew card: ' + drawn_card.name)
		draw_pile_ui_p1.update()


func calc_cumulative_probability(card_state: CombatCardState) -> float:
	var cumulative_probability = 1.0
	for card in card_state.run:
		cumulative_probability *= card.get_probability()
		combat_log.log_event('probability: ' + str(cumulative_probability))
	return cumulative_probability


func evaluate_effects(card_state: CombatCardState) -> void:
	var run_index : int = 0
	for card in card_state.run:
		card.apply_run_effect(
			run_index,
			get_stats_current_player(),
			get_stats_noncurrent_player(),
			card_state_current_player,
			get_card_state_noncurrent_player()
		)
		run_index += 1


func close_run(card_state: CombatCardState) -> void:
	combat_log.log_event('close run')
	var pcnt_chance = calc_cumulative_probability(card_state)
	combat_log.log_event('need to beat: ' + str(1-pcnt_chance))
	var roll = randf()
	combat_log.log_event('roll: ' + str(roll))
	if roll > (1-pcnt_chance):
		combat_log.log_event('roll succeeds')
		evaluate_effects(card_state)
	for child in run_hbox.get_children():
		child.queue_free()
	card_state.run = []
	card_state.run_probability = 1.0
	card_state.draw_pile = card_state.source_draw_pile.duplicate(true)
	draw_pile_ui_p1.update()


func _on_death(stats: Stats) -> void:
	'''
	Needs to account for player vs AI
	'''
	combat_log.log_event(stats.name + ' is dead!')
	var new_end_menu = end_menu_scene.instantiate()
	menu_ui.add_child(new_end_menu)
	
	
		


	
	





		
