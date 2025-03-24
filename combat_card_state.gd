class_name CombatCardState
extends RefCounted

#signal card_drawn(card: CombatCard)
signal card_moved(controller: PlayerController, card: CombatCard, from: CardTarget, to: CardTarget)
signal card_added(controller: PlayerController, card: CombatCard, to: CardTarget, source: Node) #Not sure what to do about source

signal hand_stats_updated
signal lost

'''
this is basically a data container for combat scene state
'''

const MOVE_TIME : float = 1.2

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
var hand_base_attack: int
var hand_base_defense: int
var hand_attack_mult: float
var hand_defense_mult: float
var hand_attack: int
var hand_defense: int

var pile_mapping := {
	CardTarget.DECK: deck as Array[CombatCard],
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
	print('MOVE CARD (' + CombatScene.Player.keys()[controller.player] + '): ' + card.get_card_name() + ' FROM ' + CardTarget.keys()[from_pile] + ' TO ' + CardTarget.keys()[to_pile])
	# NOTE/TODO: do we need to perform a check here to make sure the card is still in the from pile
	# e.g. if 6 cards are in a failed hand, and card 1 has already moved the card 3 out of the hand
	# for some reason, when Card 3 goes to move itself out of the hand, we're gonna have issues
	if not pile_mapping[from_pile].has(card):
		print('WARNING: CARD: ' + card.get_card_name() + ' HAS ALREADY BEEN MOVED FROM: ' + CardTarget.keys()[from_pile])
	
	pile_mapping[from_pile].erase(card)
	pile_mapping[to_pile].append(card)

	_calc_hand_stats()
	card_moved.emit(controller, card, from_pile, to_pile)

	await controller.get_tree().create_timer(MOVE_TIME).timeout
	
	
func add_card(card: CombatCard, to_pile: CardTarget, source: Node = controller.ui.stats) -> void:
	pile_mapping[to_pile].append(card)

	_calc_hand_stats()
	card_added.emit(controller, card, to_pile, source)
	
	await controller.get_tree().create_timer(MOVE_TIME).timeout

	
	
func return_first_instance(card: CombatCard, pile: CardTarget) -> CombatCard: #returns either Combat Card or Null
	var first_instance: CombatCard
	for iter_card in pile_mapping[pile]:
		if iter_card.get_script() == card.get_script():
		#if is_instance_of(card, iter_card.get_class()):
			first_instance = iter_card
			break
	#if first_instance: #leftover from when it was pop first instance
		#pile_mapping[pile].erase(first_instance)
	return first_instance


#TODO: update this to reflect damage and absorb
func _calc_hand_stats() -> void:
	reset_hand_stats()
	for card in hand:
		hand_fate -= card.get_fate_cost()
		hand_base_attack += card.get_attack(hand)
		hand_base_defense += card.get_defense(hand)
		hand_attack_mult += card.get_attack_mult(hand)
		hand_defense_mult += card.get_defense_mult(hand)
		
	hand_attack = round(hand_base_attack * (1.0 + hand_attack_mult))
	hand_defense = round(hand_base_defense * (1.0 + hand_defense_mult))
	hand_stats_updated.emit()
	
	
func reset_hand_stats() -> void:
	hand_fate = 1.0
	hand_base_attack = 0
	hand_base_defense = 0
	hand_attack_mult = 0.0
	hand_defense_mult = 0.0
	hand_attack = 0
	hand_defense = 0
	#hand_stats_updated.emit()


func perform_loss_check() -> bool:
	if not discard_pile and not deck and not hand:
		return true
	return false


func get_cards_as_str(pile: CardTarget) -> String:
	var names = []
	for card in pile_mapping[pile]:
		names.append(card.get_card_name())
	return ', '.join(names)

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
	hand_attack = 0
	hand_defense = 0


func init_deck(card_database: CardDatabase, source_deck: Deck, combat_ui_manager: CombatUIManager) -> void:
	deck.clear()
	
	for card_id in source_deck.cards:
		for i in range(source_deck.cards[card_id]):
			var copy = card_database.get_card(card_id)
			copy.combat_ui_manager = combat_ui_manager
			deck.append(copy)
			
	deck.shuffle()
	#_card_state_changed()


func reshuffle_discard() -> void:
	var discard_copy = discard_pile.duplicate()
	for card in discard_copy:
		move_card(card, CardTarget.DISCARD, CardTarget.DECK)
	deck.shuffle()
	
	
	
	
#func move_card(card: CombatCard, from_pile: CardTarget, to_pile: CardTarget) -> void:
	#pile_mapping[to_pile].append(card)
	#pile_mapping[from_pile].erase(card)
	
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
