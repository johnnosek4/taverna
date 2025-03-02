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
var current_controller: PlayerController
var card_state_current_player: CombatCardState
var p1_ui: PlayerUI
var p2_ui: PlayerUI

const card_ui_scene = preload("res://ui/card_ui.tscn")
const end_menu_scene = preload("res://ui/menus/end_game_menu.tscn")

#@onready var draw_button = %DrawButton
#@onready var end_turn_button = %EndTurnButton
@onready var run_hbox_p1 = %RunHBoxP1
@onready var run_hbox_p2 = %RunHBoxP2

@onready var player1_stats_ui = %Player1StatsUI
@onready var player2_stats_ui = %Player2StatsUI

@onready var draw_pile_ui_p1 = %DrawPileUIP1
@onready var draw_pile_ui_p2 = %DrawPileUIP2

@onready var combat_log = %CombatLog
@onready var menu_ui = %MenuUI


'''
contains the combat controller
'''

func _ready():
	test()
	#draw_button.pressed.connect(draw_card.bind(card_state_current_player))
	#end_turn_button.pressed.connect(execute_run.bind(card_state_current_player))
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
	draw_pile_ui_p2.card_state = p2_combat_cards_state
	draw_pile_ui_p2.update()
	
	p1_combat_cards_state.card_drawn.connect(draw_card_ui)
	p2_combat_cards_state.card_drawn.connect(draw_card_ui)
	
	p1_ui = PlayerUI.new()
	p2_ui = PlayerUI.new()
	
	p1_ui.run = run_hbox_p1
	p1_ui.stats = player1_stats_ui
	p1_ui.draw_pile = draw_pile_ui_p1
	
	p2_ui.run = run_hbox_p2
	p2_ui.stats = player2_stats_ui
	p2_ui.draw_pile = draw_pile_ui_p2
	
	p1_controller = HumanController.new() if p1_stats.player_type == Stats.PlayerType.HUMAN else AIController.new()
	p2_controller = HumanController.new() if p2_stats.player_type == Stats.PlayerType.HUMAN else AIController.new()
	p1_controller.stats = p1_stats
	p1_controller.combat_cards = p1_combat_cards_state
	p1_controller.ui = p1_ui
	p2_controller.stats = p2_stats
	p2_controller.combat_cards = p2_combat_cards_state
	p2_controller.ui = p2_ui
	add_child(p1_controller)
	add_child(p2_controller)

	p1_controller.on_turn_ended = _on_turn_ended
	p2_controller.on_turn_ended = _on_turn_ended
	
	current_controller = p1_controller
	
	current_controller.start_turn()

func test() -> void:
	var card1 = Strike.new()
	var card2 = Strike.new()
	var card3 = Strike.new()
	var card4 = Lunge.new()
	
	p1_stats = Stats.new()
	p1_stats.card_pile = [card1, card4]
	p1_stats.deck = [card1, card2, card3, card4]
	p2_stats = Stats.new()
	p2_stats.name = "Opponent"
	#p2_stats.player_type = Stats.PlayerType.AI
	p2_stats.deck = [card1, card2, card3, card4]
	
	initialize_combat_state()

func set_current_controller() -> void:
	pass
	
func switch_current_controller() -> void:
	current_controller = p1_controller if current_controller == p2_controller else p2_controller
	combat_log.log_event('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
	combat_log.log_event(current_controller.stats.name + 's turn!')
	
func prompt_player_turn() -> void:
	pass

func initialize_combat_state() -> void:
	p1_combat_cards_state = CombatCardState.new()
	p1_combat_cards_state.source_draw_pile = p1_stats.deck.duplicate(true)
	p1_combat_cards_state.reshuffle_draw_pile()
	
	p2_combat_cards_state = CombatCardState.new()
	p2_combat_cards_state.source_draw_pile = p2_stats.deck.duplicate(true)
	p2_combat_cards_state.reshuffle_draw_pile()


func get_noncurrent_controller() -> PlayerController:
	return p1_controller if current_controller == p2_controller else p2_controller


#func get_card_state_noncurrent_player() -> CombatCardState:
	#return p2_combat_cards_state if card_state_current_player == p1_combat_cards_state else p1_combat_cards_state
#
#func get_stats_current_player() -> Stats:
	#return p2_stats if card_state_current_player == p2_combat_cards_state else p1_stats
#
#func get_stats_noncurrent_player() -> Stats:
	#return p1_stats if card_state_current_player == p2_combat_cards_state else p2_stats

#could make these functional and return a copy of the card state, but not sure of performance impacts
#func reshuffle_draw_pile(card_state: CombatCardState) -> void:
	#card_state.draw_pile = card_state.source_draw_pile.duplicate(true)
	#card_state.draw_pile.shuffle()


#func draw_card(card_state: CombatCardState) -> void:
	#if len(card_state.draw_pile) > 0:
		##Game Logic
		#var drawn_card = card_state.draw_pile.pop_front()
		#card_state.run.append(drawn_card)
		#
func draw_card_ui(card: CombatCard) -> void:
	#UI Stuff
	var new_card_ui = card_ui_scene.instantiate()
	new_card_ui.card = card
	
	#var run_hbox = run_hbox_p1 if current_controller == p1_controller else run_hbox_p2
	#var draw_pile = draw_pile_ui_p1 if current_controller == p1_controller else draw_pile_ui_p2

	current_controller.ui.run.add_child(new_card_ui)
	
	var prob = calc_cumulative_probability(current_controller.combat_cards)
	combat_log.log_event(current_controller.stats.name + ' drew card: ' + card.name + ' - new probability: ' + str(prob).pad_decimals(2))
	current_controller.ui.draw_pile.update()


func calc_cumulative_probability(card_state: CombatCardState) -> float:
	var cumulative_probability = 1.0
	for card in card_state.run:
		cumulative_probability *= card.get_probability()
	#combat_log.log_event('Chances: ' + str(cumulative_probability))
	return cumulative_probability


func evaluate_effects(card_state: CombatCardState) -> void:
	var run_index : int = 0
	var noncurrent_controller = get_noncurrent_controller()
	for card in card_state.run:
		card.apply_run_effect(
			run_index,
			current_controller.stats,
			noncurrent_controller.stats,
			current_controller.combat_cards,
			noncurrent_controller.combat_cards
		)
		run_index += 1


func _on_turn_ended() -> void:
	execute_run()
	switch_current_controller()
	print('current controller: ', current_controller)
	current_controller.start_turn()


func execute_run() -> void:
	var card_state = current_controller.combat_cards
	combat_log.log_event('Roll the bones!')
	var pcnt_chance = calc_cumulative_probability(card_state)
	combat_log.log_event('Roll to beat: ' + str(1-pcnt_chance))
	var roll = randf()
	combat_log.log_event('Roll: ' + str(roll).pad_decimals(2))
	if roll > (1-pcnt_chance):
		combat_log.log_event('Roll passes!')
		evaluate_effects(card_state)
	else:
		combat_log.log_event('Roll fails!')
	for child in current_controller.ui.run.get_children():
		child.queue_free()
	card_state.run = []
	card_state.run_probability = 1.0
	card_state.draw_pile = card_state.source_draw_pile.duplicate(true)
	current_controller.ui.draw_pile.update()


func _on_death(stats: Stats) -> void:
	'''
	Needs to account for player vs AI
	'''
	combat_log.log_event(stats.name + ' is dead!')
	var new_end_menu = end_menu_scene.instantiate()
	menu_ui.add_child(new_end_menu)
	
	
		


	
	





		
