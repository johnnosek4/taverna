class_name PlayerController
extends Node

signal card_drawn(card: CombatCard)

var stats: Stats
var combat_cards: CombatCardState
var ui: PlayerUI
var controllers_turn: bool = false
var on_turn_ended: Callable
var on_card_drawn: Callable

func start_turn() -> void:
	print('start turn for: ' + stats.name)
	combat_cards.draw_pile.shuffle()
	stats.update_effect_durations()
	#Adding in this timer because I suspect the 'roll' event input is causing issues by 'lasting too long'
	#and getting called even after the controller switchover
	await get_tree().create_timer(0.5).timeout
	controllers_turn = true
	#Update duration of all effects


func draw_card(): #optionally returns a combat card if one exists
	if len(combat_cards.draw_pile) > 0:
		var drawn_card = combat_cards.draw_pile.pop_front()
		combat_cards.run.append(drawn_card)
		card_drawn.emit(drawn_card)
		return drawn_card
		
	if len(combat_cards.draw_pile) == 0:
		end_turn()

		#drawn_card.on_draw_effect(
			#
		#)
	


func end_turn() -> void:
	controllers_turn = false
	print('end turn for: ' + stats.name)
	on_turn_ended.call()
	
