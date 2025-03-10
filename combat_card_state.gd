class_name CombatCardState
extends RefCounted

#signal card_drawn(card: CombatCard)

'''
this is basically a data container for combat scene state
'''

var deck: Array[CombatCard] = []
var drawn_card: CombatCard #TODO: decide if this is actually necessary?  maybe for UI?
var discard_pile: Array[CombatCard] = []
var graveyard_pile: Array[CombatCard] = []
var hand: Array[CombatCard] = []
var hand_fate: float
var hand_power: int
var hand_toughness: int


func draw_card() -> void:
	if len(deck) > 0:
		var card = deck.pop_back()
		drawn_card = card
		hand.append(card)
		calc_hand_stats()
		#card_drawn.emit(drawn_card)


func calc_hand_stats() -> void:
	var fate: float = 1.0
	var power: int = 0
	var toughness: int = 0
	for card in hand:
		#if fateless continue
		fate -= 0.10
		power += card.power
		toughness += card.toughness
		
	hand_fate = fate
	hand_power = power
	hand_toughness = toughness
	#EMIT SIGNAL?


#func reset hand stats function? at the end of the round?
#maybe a reset state func that also wipes the drawn card,
#OR maybe this should just be handled by the controller...
func reset_round() -> void:
	drawn_card = null
	hand = [] #will need to check for cards that have ENDURE ability
	hand_fate = 1.0
	hand_power = 0
	hand_toughness = 0


func init_deck(source_deck: Array[CombatCard]) -> void:
	#TODO: I think we may need a custom duplicate to actually duplicate card instances
	for card in source_deck:
		deck.append(card.get_copy())
	deck.shuffle()


func reshuffle_discard() -> void:
	deck = discard_pile
	discard_pile = []
	deck.shuffle()
