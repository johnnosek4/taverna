class_name CombatScene
extends Node2D

'''
for now we'll plan on p1 is a human player and p2 is an AI opponent
but as best we can, try and plan for PVP

there are two PRIMARY phases of combat
>the setup
>the action
all different player modes revolve around handling the setup
differently, but they all converge at the action, where both
players' hands are known and things can go from there.

not quite sure how to handle the different setups but for now
we'll assume hotseat, and then focus on the Action Logic

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
var rolling: bool = false
var p1_setup: bool = false #these are the variables used to determine when to start the Action
var p2_setup: bool = false

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

#func _ready():
	#initialize_combat_state()
	#draw_button.pressed.connect(draw_card.bind(card_state_current_player))
	#end_turn_button.pressed.connect(execute_run.bind(card_state_current_player))

func initialize() -> void:
	p1_combat_cards_state = CombatCardState.new()
	p1_combat_cards_state.init_deck(p1_stats.deck)
	
	p2_combat_cards_state = CombatCardState.new()
	p2_combat_cards_state.init_deck(p2_stats.deck)
	
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
	
	#TODO: streamline initialization and configuration of controllers
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
	
	#p1_controller.card_drawn.connect(draw_card_ui)
	#p2_controller.card_drawn.connect(draw_card_ui)

	p1_controller.on_turn_ended = on_turn_ended
	p1_controller.on_card_drawn = on_card_drawn
	p2_controller.on_turn_ended = on_turn_ended
	p2_controller.on_card_drawn = on_card_drawn
	
	current_controller = p1_controller
	
	current_controller.start_turn()


func switch_current_controller() -> void:
	current_controller = p1_controller if current_controller == p2_controller else p2_controller
	combat_log.log_event('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
	combat_log.log_event(current_controller.stats.name + 's turn!')


func get_noncurrent_controller() -> PlayerController:
	return p1_controller if current_controller == p2_controller else p2_controller


func draw_card_ui(card: CombatCard) -> void:
	var new_card_ui = card_ui_scene.instantiate()
	new_card_ui.card = card
	
	current_controller.ui.run.add_child(new_card_ui)
	
	var prob = calc_cumulative_probability(current_controller.combat_cards, current_controller.stats.effects)
	combat_log.log_event(current_controller.stats.name + ' drew card: ' + card.name + ' - new probability: ' + str(prob).pad_decimals(2))
	current_controller.ui.draw_pile.update()
	#await get_tree().create_timer(0.5).timeout #TEMP: just to allow people to process card draws that 'end turn'


func calc_cumulative_probability(card_state: CombatCardState, effects: Array[Effect]) -> float:
	var cumulative_probability = 1.0
	for card in card_state.run:
		cumulative_probability *= card.get_probability()
	#combat_log.log_event('Chances: ' + str(cumulative_probability))
	for effect in effects:
		cumulative_probability = effect.modify_roll_probability(cumulative_probability)
	return cumulative_probability


func on_turn_ended(controller: PlayerController) -> void:
	# Update readiness for action based on which controllers have called the callback
	if controller == p1_controller:
		p1_setup = true
	else:
		p2_setup = true
		
	# Check whether both setups are complete
	if p1_setup and p2_setup:
		#Kick Off Action Logic
		pass
		
	# MAYBEE call an end turn here or dispatch to a new func
	# to determine what happens next based off the game mode
	# would definitely need to await completion of the action tho
	#switch_current_controller()
	#current_controller.start_turn()


func evaluate_effects(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	'''
	I'm not sure if its here, but I do think we want something that pauses on each card and evaluates it
	so we can't really switch turns and start the next persons turn until
	we've gone through and done that
	we'd probably attach a little animation to each and wait for animation to complete before
	processing the next one
	'''
	var run_index : int = 0
	var card_uis = current_controller.ui.run.get_children() #UI
	for card in current_controller.combat_cards.run:
		var card_ui = card_uis[run_index] as CardUI
		card_ui.select()
		card.apply_run_effect(
			combat_log,
			run_index,
			current_controller,
			opponent_controller
		)
		run_index += 1
		await get_tree().create_timer(1.4).timeout
		card_ui.deselect()
	return


func evaluate_on_run_fails(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	for card in current_controller.combat_cards.run:
		await card.on_run_fails(
			combat_log,
			current_controller,
			opponent_controller
		)
	return


func evaluate_before_run_starts(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	for card in current_controller.combat_cards.run:
		await card.before_run_starts(
			combat_log,
			current_controller,
			opponent_controller
		)
	return
	

func evaluate_after_run_completes(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	for card in current_controller.combat_cards.run:
		await card.after_run_completes(
			combat_log,
			current_controller,
			opponent_controller
		)
	return


func roll_run(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	print('START ROLL - SETTING ROLLING TO TRUE')
	rolling = true
	await evaluate_before_run_starts(current_controller, opponent_controller)
	var card_state = current_controller.combat_cards
	combat_log.log_event('Roll the bones!')
	await get_tree().create_timer(0.2).timeout
	var pcnt_chance = calc_cumulative_probability(card_state, current_controller.stats.effects)
	combat_log.log_event('Roll to beat: ' + str(1-pcnt_chance))
	await get_tree().create_timer(0.2).timeout
	var roll = randf()
	combat_log.log_event('Roll: ' + str(roll).pad_decimals(2))
	await get_tree().create_timer(0.2).timeout
	if roll > (1-pcnt_chance):
		print('ROLL PASSES')
		combat_log.log_event('Roll passes!')
		await get_tree().create_timer(0.2).timeout
		'''
		alright, so TNT, disengage is calling end_turn within
		this await block, so card_state.run = [] has not yet
		run by the time disengage calls end_turn which then
		check card_state.run to see if it should roll existing cards
		thus resulting in roll occurring a second time.
		'''
		await evaluate_effects(current_controller, opponent_controller)
		await evaluate_after_run_completes(current_controller, opponent_controller)
	else:
		print('ROLL FAILS')
		combat_log.log_event('Roll fails!')
		await evaluate_on_run_fails(current_controller, opponent_controller)
	for child in current_controller.ui.run.get_children():
		child.queue_free()
	card_state.run = []
	card_state.run_probability = 1.0
	print('FINISH ROLL - SETTING ROLLING TO FALSE')
	rolling = false
	return


func _on_death(stats: Stats) -> void:
	#TODO: Needs to account for player vs AI
	combat_log.log_event(stats.name + ' is dead!')
	var new_end_menu = end_menu_scene.instantiate()
	menu_ui.add_child(new_end_menu)
	
	
func on_card_drawn(card: CombatCard) -> void:
	draw_card_ui(card)
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
