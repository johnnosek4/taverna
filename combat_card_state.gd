class_name CombatCardState
extends RefCounted

signal card_drawn(card: CombatCard)

'''
this is basically a data container for combat scene state
'''

var source_draw_pile: Array
var draw_pile: Array
var carry_pile: Array = []
var run: Array = []
var run_probability: float
var run_dmg: int


func draw_card() -> void:
	if len(draw_pile) > 0:
		#Game Logic
		var drawn_card = draw_pile.pop_front()
		run.append(drawn_card)
		card_drawn.emit(drawn_card)
		


func reshuffle_draw_pile() -> void:
	draw_pile = source_draw_pile.duplicate(true)
	draw_pile.shuffle()
