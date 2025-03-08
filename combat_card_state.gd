class_name CombatCardState
extends RefCounted

#signal card_drawn(card: CombatCard)

'''
this is basically a data container for combat scene state
'''

var source_draw_pile: Array
var draw_pile: Array
var bank_pile: Array = []
var drawn_card: CombatCard
var run: Array = []
var run_probability: float
var run_dmg: int

#going to try to move this to player controller for now
#func draw_card() -> void:
	#if len(draw_pile) > 0:
		##Game Logic
		#var drawn_card = draw_pile.pop_front()
		#run.append(drawn_card)
		#card_drawn.emit(drawn_card)


func reshuffle_draw_pile() -> void:
	draw_pile = source_draw_pile.duplicate(true)
	draw_pile.shuffle()
