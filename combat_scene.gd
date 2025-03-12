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

enum Player {
	ONE,
	TWO
}


var p1_stats: Stats #Persistent Player State
var p2_stats: Stats
var p1_combat_cards_state: CombatCardState #Card State for ONLY one combat
var p2_combat_cards_state: CombatCardState
var p1_controller: PlayerController
var p2_controller: PlayerController
var controllers: Array[PlayerController]
var current_controller_idx: int = 0 #this is purely for determining whether setup is done concurrently, or serially
var p1_ui: PlayerUI #Convenience class for grouping all UI elements of single player into one interface
var p2_ui: PlayerUI
var rolling: bool = false
var p1_is_setup: bool = false #these are the variables used to determine when to start the Action
var p2_is_setup: bool = false
var mode: Run.Mode = Run.Mode.HOTSEAT

const card_ui_scene = preload("res://ui/card_ui.tscn")
const end_menu_scene = preload("res://ui/menus/end_game_menu.tscn")
const deck_builder_scene = preload("res://ui/menus/deck/deck_builder_ui.tscn")

@onready var card_animator: CardAnimator = %CardAnimator

@onready var draw_pile_p2: StackPileUI = %DrawPileP2
@onready var spread_pile_p2: SpreadPileUI = %SpreadPileP2
@onready var discard_pile_p2: StackPileUI = %DiscardPileP2
@onready var graveyard_pile_p2: StackPileUI = %GraveyardPileP2

@onready var discard_pile_p1: StackPileUI = %DiscardPileP1
@onready var spread_pile_p1: SpreadPileUI = %SpreadPileP1
@onready var draw_pile_p1: StackPileUI = %DrawPileP1
@onready var graveyard_pile_p1: StackPileUI = %GraveyardPileP1

@onready var player1_stats_ui = %Player1StatsUI
@onready var player2_stats_ui = %Player2StatsUI

@onready var hand_stats_ui_p1: HandStatsUI = %HandStatsUIP1
@onready var hand_stats_ui_p2: HandStatsUI = %HandStatsUIP2

@onready var combat_log = %CombatLog
@onready var menu_ui = %MenuUI

#@onready var draw_button = %DrawButton
#@onready var end_setup_button = %EndsetupButton
@onready var view_cards_button: Button = %ViewCardsButton


func initialize() -> void:
	p1_combat_cards_state = CombatCardState.new()
	p1_combat_cards_state.init_deck(p1_stats.deck)
	p1_combat_cards_state.card_moved.connect(card_animator.move_card_with_animation)
	p1_combat_cards_state.card_added.connect(card_animator.add_card_with_animation)

	
	p2_combat_cards_state = CombatCardState.new()
	p2_combat_cards_state.init_deck(p2_stats.deck)
	p2_combat_cards_state.card_moved.connect(card_animator.move_card_with_animation)
	p2_combat_cards_state.card_added.connect(card_animator.add_card_with_animation)


	#view_cards_button.pressed.connect(_on_view_cards_pressed)
	
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
	
	draw_pile_p1.card_pile = p1_combat_cards_state.deck
	draw_pile_p1.update()
	draw_pile_p2.card_pile = p2_combat_cards_state.deck
	draw_pile_p2.update()
	discard_pile_p1.card_pile = p1_combat_cards_state.discard_pile
	discard_pile_p1.update()
	discard_pile_p2.card_pile = p2_combat_cards_state.discard_pile
	discard_pile_p2.update()
	graveyard_pile_p1.card_pile = p1_combat_cards_state.graveyard_pile
	graveyard_pile_p1.update()
	graveyard_pile_p2.card_pile = p2_combat_cards_state.graveyard_pile
	graveyard_pile_p2.update()
	
	hand_stats_ui_p1.combat_cards = p1_combat_cards_state
	hand_stats_ui_p1.update()
	hand_stats_ui_p2.combat_cards = p2_combat_cards_state
	hand_stats_ui_p2.update()
	p1_combat_cards_state.hand_stats_updated.connect(hand_stats_ui_p1.update)
	p2_combat_cards_state.hand_stats_updated.connect(hand_stats_ui_p2.update)
	#p1_combat_cards_state.card_moved.connect(update_card_ui_p1)
	#p2_combat_cards_state.card_moved.connect(update_card_ui_p2)
	
	p1_ui = PlayerUI.new()
	p2_ui = PlayerUI.new()
	
	p1_ui.stats = player1_stats_ui
	p1_ui.hand_stats = hand_stats_ui_p1
	
	p2_ui.stats = player2_stats_ui
	p2_ui.hand_stats = hand_stats_ui_p2
	
	#TODO: streamline initialization and configuration of controllers
	p1_controller = HumanController.new() if p1_stats.player_type == Stats.PlayerType.HUMAN else AIController.new()
	p2_controller = HumanController.new() if p2_stats.player_type == Stats.PlayerType.HUMAN else AIController.new()
	p1_combat_cards_state.controller = p1_controller #NOTE: I HATE THIS; can we replace with enum or something else at some point??
	p1_controller.stats = p1_stats
	p1_controller.combat_cards = p1_combat_cards_state
	p1_controller.ui = p1_ui
	p2_combat_cards_state.controller = p2_controller
	p2_controller.stats = p2_stats
	p2_controller.combat_cards = p2_combat_cards_state
	p2_controller.ui = p2_ui
	add_child(p1_controller)
	add_child(p2_controller)

	p1_controller.player = Player.ONE
	p2_controller.player = Player.TWO
	p1_controller.combat_log = combat_log
	p2_controller.combat_log = combat_log
	p1_controller.on_setup_ended = on_setup_ended
	p1_controller.on_card_drawn = on_card_drawn
	p2_controller.on_setup_ended = on_setup_ended
	p2_controller.on_card_drawn = on_card_drawn
	
	controllers = [p1_controller, p2_controller]
	
	card_animator.setup_ui_mapping(
		draw_pile_p1,
		discard_pile_p1,
		graveyard_pile_p1,
		spread_pile_p1,
		discard_pile_p1,
		draw_pile_p2,
		discard_pile_p2,
		graveyard_pile_p2,
		spread_pile_p2,
		discard_pile_p2
	)


func start_combat() -> void:
	start_round()


func start_round() -> void:
	if mode == Run.Mode.HOTSEAT:
		controllers[current_controller_idx].start_setup()
	else:
		for controller in controllers:
			controller.start_setup()


func end_round() -> void:
	if p1_controller.combat_cards.perform_loss_check():
		_on_death(p1_controller.stats)
	if p2_controller.combat_cards.perform_loss_check():
		_on_death(p2_controller.stats)
	
	# TODO: implement method on spread piles to reorganize 
	# and call it here (e.g. Endure may mean some spaces after discard)
	# might need this for stack piles too, i'm not sure
	
	# TODO: also need to call a function on abilities of cards remaining to update their states as well
	# e.g. if something endures but also gains +1 attack at the end of the round
	
	combat_log.log_event('Round Ends!')
	
	p1_is_setup = false
	p2_is_setup = false
	
	start_round()


func on_setup_ended(controller: PlayerController) -> void:
	# Update readiness for action based on which controllers have called the callback
	if controller == p1_controller:
		p1_is_setup = true
		if mode == Run.Mode.HOTSEAT:
			switch_current_controller()
			controllers[current_controller_idx].start_setup()
	else:
		p2_is_setup = true
		if mode == Run.Mode.HOTSEAT:
			switch_current_controller()
		
	# Check whether both setups are complete
	if p1_is_setup and p2_is_setup:
		#Kick Off Action Logic
		start_action()


func switch_current_controller() -> void:
	current_controller_idx = wrapi(current_controller_idx + 1,0,2)
	combat_log.log_event('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')


func get_opposing_controller(controller: PlayerController) -> PlayerController:
	return p1_controller if controller == p2_controller else p2_controller


func _on_death(stats: Stats) -> void: #TODO: move up to run?
	#TODO: Needs to account for player vs AI
	combat_log.log_event(stats.name + ' is dead!')
	var new_end_menu = end_menu_scene.instantiate()
	menu_ui.add_child(new_end_menu)
	
	
func on_card_drawn(controller: PlayerController, card: CombatCard) -> void:
	#draw_card_ui(controller, card)
	card.on_draw(
		controller,
		get_opposing_controller(controller),
	)

################ START ACTION #################

func start_action() -> void:
	var p1_action: bool = false
	var p2_action: bool = false
	
	#ROLL fate of each hand
	var p1_roll = randi_range(0,9)
	var p2_roll = randi_range(0,9)
	
	# CHECK against hand fates
	if p1_roll >= int((1 - p1_controller.combat_cards.hand_fate) * 10):
		combat_log.log_event('P1 Action Succeeds with a roll of ' + str(p1_roll) + ' vs fate of ' + str(p1_controller.combat_cards.hand_fate).pad_decimals(2) + '%')
		p1_action = true
	else:
		combat_log.log_event('P1 Action Fails with a roll of ' + str(p1_roll) + ' vs fate of ' + str(p1_controller.combat_cards.hand_fate).pad_decimals(2) +'%')
		
	if p2_roll >= int((1 - p2_controller.combat_cards.hand_fate) * 10):
		combat_log.log_event('P2 Action Succeeds with a roll of ' + str(p2_roll) + ' vs fate of ' + str(p2_controller.combat_cards.hand_fate).pad_decimals(2) + '%')
		p2_action = true
	else:
		combat_log.log_event('P2 Action Fails with a roll of ' + str(p2_roll) + ' vs fate of ' + str(p2_controller.combat_cards.hand_fate).pad_decimals(2) +'%')

	# TRIGGER on_action_succedes/fails abilities
	if p1_action:
		for card in p1_controller.combat_cards.hand:
			card.on_action_succedes(p1_controller, p2_controller)
	else:
		for card in p1_controller.combat_cards.hand:
			card.on_action_fails(p1_controller, p2_controller)
	if p2_action:
		for card in p2_controller.combat_cards.hand:
			card.on_action_succedes(p2_controller, p1_controller)
	else:
		for card in p2_controller.combat_cards.hand:
			card.on_action_fails(p2_controller, p1_controller)
	
	# Combat branches based on action outcomes
	if p1_action and p2_action:
		# DETERMINE Attacker / Defender if both actions succede
		var attacker: PlayerController
		var defender: PlayerController
		if p1_controller.combat_cards.hand_power > p2_controller.combat_cards.hand_power:
			attacker = p1_controller
		elif p1_controller.combat_cards.hand_power < p2_controller.combat_cards.hand_power:
			attacker = p2_controller
		else:
			if p1_controller.combat_cards.hand_fate > p2_controller.combat_cards.hand_fate:
				attacker = p1_controller
			elif p1_controller.combat_cards.hand_fate < p2_controller.combat_cards.hand_fate:
				attacker = p2_controller
			else:
				if randi_range(0,1):
					attacker = p1_controller
				else:
					attacker = p2_controller
		defender = p1_controller if attacker == p2_controller else p2_controller
		combat_log.log_event('Attacker is ' + attacker.stats.name + ', Defender is ' + defender.stats.name)

		
		# DETERMINE whether attack or defend succedes
		if attacker.combat_cards.hand_power > defender.combat_cards.hand_toughness:
			# Subtract spillover from defender HP
			var dmg = attacker.combat_cards.hand_power - defender.combat_cards.hand_toughness
			defender.stats.apply_damage(dmg)
			combat_log.log_event('Attacker(' + attacker.stats.name + ') succeedes and deals ' + str(dmg) + ' damage!')


			# Destroy all cards in defenders hand (calling on destroy)
			# NOTE: this is all kinda throwaway, prototype stuff.  Cuz we'll need
			# to be more dynamic with things like Void.  E.g. no way to erase the card via void as constructed below
			# NOTE: maybe we wanna dupe card state entirely at the start of this process? just depends on mechanics and whether we want changes at one step to affect the next step
			var defender_hand = defender.combat_cards.hand.duplicate()
			while defender_hand:
				var card = defender_hand.pop_front()
				await card.on_destroy(defender, attacker)

			
			# Call on_attack_succedes abilities in attackers hand
			# Discard all cards in attackers hand (calling on_discard)
			var attacker_hand = attacker.combat_cards.hand.duplicate()
			while attacker_hand:
				var card = attacker_hand.pop_front()
				await card.on_attack_succedes(attacker, defender)
				await card.on_discard(attacker, defender) #can this go here or should it go somehwere else
			
			
		else: # Succesful Defence
			# Call on_defend_succedes in defenders hand #TODO: move into funcs
			combat_log.log_event('Defender(' + defender.stats.name + ') succeedes!')

			var defender_hand = defender.combat_cards.hand.duplicate()
			while defender_hand:
				var card = defender_hand.pop_front()
				await card.on_defend_succedes(defender, attacker)
			
			# Discard all cards in defenders hand
			await discard_hand(defender, attacker)

			# Discard all cards in attackers hand
			await discard_hand(attacker, defender)


	elif p1_action and not p2_action:
		var dmg = p1_controller.combat_cards.hand_power
		p2_controller.stats.apply_damage(dmg)
		combat_log.log_event(p1_controller.stats.name + ' deals '+str(dmg)+ ' damage to ' + p2_controller.stats.name)

		await discard_hand(p1_controller, p2_controller)
		await discard_hand(p2_controller, p1_controller)
	elif not p1_action and p2_action:
		var dmg = p2_controller.combat_cards.hand_power
		p1_controller.stats.apply_damage(dmg)
		combat_log.log_event(p2_controller.stats.name + ' deals '+str(dmg)+ ' damage to ' + p1_controller.stats.name)

		await discard_hand(p1_controller, p2_controller)
		await discard_hand(p2_controller, p1_controller)
	else:
		# Both rolls fail
		combat_log.log_event('Both Actions Fail!')
		await discard_hand(p1_controller, p2_controller)
		await discard_hand(p2_controller, p1_controller)
	
	end_round()


static func discard_hand(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	var cur_controller_hand = cur_controller.combat_cards.hand.duplicate()
	while cur_controller_hand:
		var card = cur_controller_hand.pop_front()
		await card.on_discard(cur_controller, opp_controller)






#func calc_cumulative_probability(card_state: CombatCardState, effects: Array[Effect]) -> float:
	#var cumulative_probability = 1.0
	#for card in card_state.run:
		#cumulative_probability *= card.get_probability()
	##combat_log.log_event('Chances: ' + str(cumulative_probability))
	#for effect in effects:
		#cumulative_probability = effect.modify_roll_probability(cumulative_probability)
	#return cumulative_probability





#func evaluate_effects(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	#'''
	#I'm not sure if its here, but I do think we want something that pauses on each card and evaluates it
	#so we can't really switch setups and start the next persons setup until
	#we've gone through and done that
	#we'd probably attach a little animation to each and wait for animation to complete before
	#processing the next one
	#'''
	#var run_index : int = 0
	#var card_uis = current_controller.ui.run.get_children() #UI
	#for card in current_controller.combat_cards.run:
		#var card_ui = card_uis[run_index] as CardUI
		#card_ui.select()
		#card.apply_run_effect(
			#combat_log,
			#run_index,
			#current_controller,
			#opponent_controller
		#)
		#run_index += 1
		#await get_tree().create_timer(1.4).timeout
		#card_ui.deselect()
	#return
#
#
#func evaluate_on_run_fails(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	#for card in current_controller.combat_cards.run:
		#await card.on_run_fails(
			#combat_log,
			#current_controller,
			#opponent_controller
		#)
	#return
#
#
#func evaluate_before_run_starts(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	#for card in current_controller.combat_cards.run:
		#await card.before_run_starts(
			#combat_log,
			#current_controller,
			#opponent_controller
		#)
	#return
	#
#
#func evaluate_after_run_completes(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	#for card in current_controller.combat_cards.run:
		#await card.after_run_completes(
			#combat_log,
			#current_controller,
			#opponent_controller
		#)
	#return
#
#
#func roll_run(current_controller: PlayerController, opponent_controller: PlayerController) -> void:
	#print('START ROLL - SETTING ROLLING TO TRUE')
	#rolling = true
	#await evaluate_before_run_starts(current_controller, opponent_controller)
	#var card_state = current_controller.combat_cards
	#combat_log.log_event('Roll the bones!')
	#await get_tree().create_timer(0.2).timeout
	#var pcnt_chance = calc_cumulative_probability(card_state, current_controller.stats.effects)
	#combat_log.log_event('Roll to beat: ' + str(1-pcnt_chance))
	#await get_tree().create_timer(0.2).timeout
	#var roll = randf()
	#combat_log.log_event('Roll: ' + str(roll).pad_decimals(2))
	#await get_tree().create_timer(0.2).timeout
	#if roll > (1-pcnt_chance):
		#print('ROLL PASSES')
		#combat_log.log_event('Roll passes!')
		#await get_tree().create_timer(0.2).timeout
		#'''
		#alright, so TNT, disengage is calling end_setup within
		#this await block, so card_state.run = [] has not yet
		#run by the time disengage calls end_setup which then
		#check card_state.run to see if it should roll existing cards
		#thus resulting in roll occurring a second time.
		#'''
		#await evaluate_effects(current_controller, opponent_controller)
		#await evaluate_after_run_completes(current_controller, opponent_controller)
	#else:
		#print('ROLL FAILS')
		#combat_log.log_event('Roll fails!')
		#await evaluate_on_run_fails(current_controller, opponent_controller)
	#for child in current_controller.ui.run.get_children():
		#child.queue_free()
	#card_state.run = []
	#card_state.run_probability = 1.0
	#print('FINISH ROLL - SETTING ROLLING TO FALSE')
	#rolling = false
	#return





#func _on_view_cards_pressed() -> void:
	#var deck_builder_menu = deck_builder_scene.instantiate()
	#deck_builder_menu.stats = current_controller.stats
	#menu_ui.add_child(deck_builder_menu)


#old code for handling card destruction
# Destroy all cards in defenders hand (calling on destroy)
# NOTE: this is all kinda throwaway, prototype stuff.  Cuz we'll need
# to be more dynamic with things like Void.  E.g. no way to erase the card via void as constructed below
# NOTE: maybe we wanna dupe card state entirely at the start of this process? just depends on mechanics and whether we want changes at one step to affect the next step
#var defender_hand = defender.combat_cards.hand.duplicate()
#while defender_hand:
	#var card = defender_hand.pop_front()
	#var destroy = await card.on_destroy(defender, attacker)
	#if destroy: #NOTE: just gonna note that I don't really like this here and would rather have it called by the controller/card, and in the _on_destroy behavior
		#defender.combat_cards.hand.erase(card)
		#defender.combat_cards.graveyard_pile.append(card)
