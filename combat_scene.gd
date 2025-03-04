class_name CombatScene
extends Node2D

'''
for now we'll plan on p1 is a human player and p2 is an AI opponent
but as best we can, try and plan for PVP
'''

var p1_stats: Stats #Persistent Player State
var p2_stats: Stats
var p1_combat_cards_state: CombatCardState #Card State for ONLY one combat
var p2_combat_cards_state: CombatCardState
var p1_controller: PlayerController
var p2_controller: PlayerController
var current_controller: PlayerController
var p1_ui: PlayerUI #Convenience class for grouping all UI elements of single player into one interface
var p2_ui: PlayerUI

const card_ui_scene = preload("res://ui/card_ui.tscn")
const end_menu_scene = preload("res://ui/menus/end_game_menu.tscn")
const deck_builder_scene = preload("res://ui/menus/deck/deck_builder_ui.tscn")

@onready var run_hbox_p1 = %RunHBoxP1
@onready var run_hbox_p2 = %RunHBoxP2

@onready var player1_stats_ui = %Player1StatsUI
@onready var player2_stats_ui = %Player2StatsUI

@onready var draw_pile_ui_p1 = %DrawPileUIP1
@onready var draw_pile_ui_p2 = %DrawPileUIP2

@onready var combat_log = %CombatLog
@onready var menu_ui = %MenuUI

#@onready var draw_button = %DrawButton
#@onready var end_turn_button = %EndTurnButton
@onready var view_cards_button: Button = %ViewCardsButton

func _ready():
	test()
	#draw_button.pressed.connect(draw_card.bind(card_state_current_player))
	#end_turn_button.pressed.connect(execute_run.bind(card_state_current_player))
	view_cards_button.pressed.connect(_on_view_cards_pressed)
	
	player1_stats_ui.stats = p1_stats
	player1_stats_ui.update()
	p1_stats.stats_changed.connect(player1_stats_ui.update)
	p1_stats.dead.connect(_on_death)
	p1_stats.logger = combat_log
	
	player2_stats_ui.stats = p2_stats
	player2_stats_ui.update()
	p2_stats.stats_changed.connect(player2_stats_ui.update)
	p2_stats.dead.connect(_on_death)
	p2_stats.logger = combat_log
	
	draw_pile_ui_p1.card_state = p1_combat_cards_state
	draw_pile_ui_p1.update()
	draw_pile_ui_p2.card_state = p2_combat_cards_state
	draw_pile_ui_p2.update()
	
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
	
	p1_controller.card_drawn.connect(draw_card_ui)
	p2_controller.card_drawn.connect(draw_card_ui)

	p1_controller.on_turn_ended = on_turn_ended
	p1_controller.on_card_drawn = on_card_drawn
	p2_controller.on_turn_ended = on_turn_ended
	p2_controller.on_card_drawn = on_card_drawn
	
	current_controller = p1_controller
	
	current_controller.start_turn()

func test() -> void:
	var card1 = Strike.new()
	var card2 = Strike.new()
	var card3 = Strike.new()
	var card4 = Lunge.new()
	var card5 = Guard.new()
	var card6 = Flourish.new()
	var card7 = Feint.new()
	var card8 = Disengage.new()
	var card9 = Passage.new()
	var card10 = Bash.new()
	var card11 = Finisher.new()
	var card12 = Measured.new()
	
	p1_stats = Stats.new()
	p1_stats.card_pile = {card1: 4, card2:1, card9:1, card11:1}
	#p1_stats.deck = [card1, card2, card3, card4]
	p1_stats.deck = [card1, card10, card10, card10, card11, card12]
	p2_stats = Stats.new()
	p2_stats.name = "Opponent"
	#p2_stats.player_type = Stats.PlayerType.AI
	#p2_stats.deck = [card1, card2, card3, card4]
	p2_stats.card_pile = {}
	p2_stats.deck = [card1, card2, card3, card12, card11, card9]
	
	initialize_combat_state()


func switch_current_controller() -> void:
	current_controller = p1_controller if current_controller == p2_controller else p2_controller
	combat_log.log_event('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
	combat_log.log_event(current_controller.stats.name + 's turn!')
	

func initialize_combat_state() -> void:
	p1_combat_cards_state = CombatCardState.new()
	p1_combat_cards_state.source_draw_pile = p1_stats.deck.duplicate(true)
	p1_combat_cards_state.reshuffle_draw_pile()
	
	p2_combat_cards_state = CombatCardState.new()
	p2_combat_cards_state.source_draw_pile = p2_stats.deck.duplicate(true)
	p2_combat_cards_state.reshuffle_draw_pile()


func get_noncurrent_controller() -> PlayerController:
	return p1_controller if current_controller == p2_controller else p2_controller


func draw_card_ui(card: CombatCard) -> void:
	var new_card_ui = card_ui_scene.instantiate()
	new_card_ui.card = card
	
	current_controller.ui.run.add_child(new_card_ui)
	
	var prob = calc_cumulative_probability(current_controller.combat_cards, current_controller.stats.effects)
	combat_log.log_event(current_controller.stats.name + ' drew card: ' + card.name + ' - new probability: ' + str(prob).pad_decimals(2))
	current_controller.ui.draw_pile.update()


func calc_cumulative_probability(card_state: CombatCardState, effects: Array[Effect]) -> float:
	var cumulative_probability = 1.0
	for card in card_state.run:
		cumulative_probability *= card.get_probability()
	#combat_log.log_event('Chances: ' + str(cumulative_probability))
	for effect in effects:
		cumulative_probability = effect.modify_roll_probability(cumulative_probability)
	return cumulative_probability


func evaluate_effects(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	var run_index : int = 0
	for card in current_controller.combat_cards.run:
		card.apply_run_effect(
			combat_log,
			run_index,
			current_controller,
			opponent_controller
		)
		run_index += 1


func on_turn_ended() -> void:
	roll_run(current_controller, get_noncurrent_controller())
	current_controller.combat_cards.draw_pile = current_controller.combat_cards.source_draw_pile.duplicate(true)
	current_controller.ui.draw_pile.update()
	switch_current_controller()
	current_controller.start_turn()


func roll_run(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	if not current_controller.combat_cards.run:
		return
	var card_state = current_controller.combat_cards
	combat_log.log_event('Roll the bones!')
	var pcnt_chance = calc_cumulative_probability(card_state, current_controller.stats.effects)
	combat_log.log_event('Roll to beat: ' + str(1-pcnt_chance))
	var roll = randf()
	combat_log.log_event('Roll: ' + str(roll).pad_decimals(2))
	if roll > (1-pcnt_chance):
		combat_log.log_event('Roll passes!')
		evaluate_effects(current_controller, opponent_controller)
	else:
		combat_log.log_event('Roll fails!')
	for child in current_controller.ui.run.get_children():
		child.queue_free()
	card_state.run = []
	card_state.run_probability = 1.0


func _on_death(stats: Stats) -> void:
	#TODO: Needs to account for player vs AI
	combat_log.log_event(stats.name + ' is dead!')
	var new_end_menu = end_menu_scene.instantiate()
	menu_ui.add_child(new_end_menu)
	
	
func on_card_drawn(card: CombatCard) -> void:
	card.on_draw_effect(
		combat_log,
		roll_run,
		current_controller,
		get_noncurrent_controller(),
	)

func _on_view_cards_pressed() -> void:
	var deck_builder_menu = deck_builder_scene.instantiate()
	deck_builder_menu.stats = current_controller.stats
	menu_ui.add_child(deck_builder_menu)
