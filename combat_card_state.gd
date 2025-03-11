class_name CombatCardState
extends RefCounted

#signal card_drawn(card: CombatCard)
signal card_moved(controller: PlayerController, card: CombatCard, from: CardTarget, to: CardTarget)
signal hand_stats_updated

'''
this is basically a data container for combat scene state
'''

enum CardTarget {
	DECK,
	DISCARD,
	GRAVEYARD,
	HAND,
	VOID,
	#DRAWN_CARD? (all the others are the same type, arrays of combat card, so i think leave this out)
}

var controller: PlayerController # Necessary when sending out the card_moved_signals
var deck: Array[CombatCard] = []
var discard_pile: Array[CombatCard] = []
var graveyard_pile: Array[CombatCard] = []
var void_pile: Array[CombatCard] = []
var hand: Array[CombatCard] = []
var drawn_card: CombatCard #TODO: decide if this is actually necessary?  maybe for UI?
var hand_fate: float
var hand_power: int
var hand_toughness: int

var pile_mapping := {
	CardTarget.DECK: deck,
	CardTarget.DISCARD: discard_pile,
	CardTarget.GRAVEYARD: graveyard_pile,
	CardTarget.HAND: hand,
	CardTarget.VOID: void_pile
}

#TODO: could probably refactor this and move card etc, tho draw card does actually use order, whereas, move card does not
func draw_card() -> void:
	if len(deck) > 0:
		var card = deck.pop_back()
		drawn_card = card
		hand.append(card)
		_calc_hand_stats()
		card_moved.emit(controller, drawn_card, CardTarget.DECK, CardTarget.HAND)


func move_card(card: CombatCard, from_pile: CardTarget, to_pile: CardTarget) -> void:
	pile_mapping[from_pile].erase(card)
	pile_mapping[to_pile].append(card)
	_calc_hand_stats()
	card_moved.emit(controller, card, from_pile, to_pile)


func _calc_hand_stats() -> void:
	var fate: float = 1.0
	var power: int = 0
	var toughness: int = 0
	for card in hand:
		#if fateless continue
		fate -= 0.10
		power += card.get_power()
		toughness += card.get_toughness()
		
	hand_fate = fate
	hand_power = power
	hand_toughness = toughness
	hand_stats_updated.emit()


#func _card_state_changed() -> void:
	#_calc_hand_stats()
	#card_state_updated.emit()
	
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
	#_card_state_changed()


func reshuffle_discard() -> void:
	var discard_copy = discard_pile.duplicate()
	#for card in 
	deck = discard_pile
	discard_pile = []
	deck.shuffle()
	#_card_state_changed()
	
	
	#OLD CODE:
	#func move_card(card: CombatCard, from: CardTarget, to: CardTarget) -> void:
	#var from_array: Array[CombatCard]
	#var to_array: Array[CombatCard]
	#match from:
		#CardTarget.DECK:
			#from_array = deck
		#CardTarget.DISCARD:
			#from_array = discard_pile
		#CardTarget.GRAVEYARD:
			#from_array = graveyard_pile
		#CardTarget.HAND:
			#from_array = hand
	#match to:
		#CardTarget.DECK:
			#to_array = deck
		#CardTarget.DISCARD:
			#to_array = discard_pile
		#CardTarget.GRAVEYARD:
			#to_array = graveyard_pile
		#CardTarget.HAND:
			#to_array = hand
		#CardTarget.VOID:
			#pass
	#from_array.erase(card)
	#if to:
		#to_array.append(card)
	#_calc_hand_stats()
	#card_moved.emit(card, from, to)
