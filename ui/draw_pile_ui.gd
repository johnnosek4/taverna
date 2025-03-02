extends Control

var card_state: CombatCardState

@onready var card_count = %CardCount

func update() -> void:
	card_count.text = str(len(card_state.draw_pile)) + ' / ' + str(len(card_state.source_draw_pile))
