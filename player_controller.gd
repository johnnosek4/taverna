class_name PlayerController
extends Node

#signal card_drawn(card: CombatCard)
'''
ideally this controller has very little state of its own
with the exception of that needed to accept and respond to inputs
otherwise its all references to other objects
'''

var player: CombatScene.Player
var stats: Stats
var combat_cards: CombatCardState
var ui: PlayerUI
var accept_inputs: bool = false

var seconds_per_round: int = 60
var seconds_left: int
var timer: Timer

var on_setup_ended: Callable
var on_card_drawn: Callable


func start_setup() -> void:
	print('start setup for: ' + stats.name)
	_start_timer()
	stats.update_effect_durations() #NOTE: may not be necessary in 2.0
	
	#Adding in this timer because I suspect the 'roll' event input is causing issues by 'lasting too long'
	#and getting called even after the controller switchover
	await get_tree().create_timer(0.5).timeout
	accept_inputs = true


func draw_card(): #optionally resetups a combat card if one exists
	combat_cards.draw_card()
	#card_drawn.emit(combat_cards.drawn_card)
	#call the callback passed by combat_controller
	if combat_cards.drawn_card:
		await on_card_drawn.call(self, combat_cards.drawn_card)
		
	if len(combat_cards.deck) == 0:
		combat_cards.reshuffle_discard()
		
	#TODO: need to update UI based on card state - signal?
	#could potentially connect signals between the attached UI and
	#the stats/card states, although I don't think that should really
	#be done here in the controller, that feels more like the 
	#responsibility of the combat scene


func end_setup() -> void:
	accept_inputs = false
	print('end setup for: ' + stats.name)
	_clear_timer()
	on_setup_ended.call(self)


func _start_timer() -> void:
	# Create a new Timer instance
	seconds_left = seconds_per_round
	timer = Timer.new()
	timer.wait_time = 1.0  # Set to trigger every second
	timer.autostart = true
	timer.one_shot = false  # Keep repeating
	add_child(timer)  # Add Timer to the scene tree

	# Connect the timeout signal to the function
	timer.timeout.connect(_on_timer_timeout)

	# Start the timer
	timer.start()


func _clear_timer() -> void:
	if timer:
		timer.queue_free()
		ui.stats.timer_label.text = "Set"


func _on_timer_timeout() -> void:
	seconds_left -= 1
	ui.stats.timer_label.text = "Time: " + str(seconds_left)
	if seconds_left == 0:
		end_setup()
		
	
