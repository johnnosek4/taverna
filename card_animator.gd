class_name CardAnimator
extends Node2D

'''
DEV notes I think theres an opportunity to sync this better with 
the playerUI (<the current object container with references to 
each player's UI objects)
'''

const card_ui_scene = preload("res://ui/card_ui.tscn")

var p1_ui_mapping := {}
var p2_ui_mapping := {}

var is_peeping_deck: bool = false
var peeped_card: Node
var peep_duration: int = 5


func peep_deck(controller: PlayerController, cards: Array[CombatCard]) -> void:
	#just implementing this for single card for now.  TODO: update for multiple cards in future
	var card = cards.back()
	
	# Instantiate card ui for tween
	peeped_card = card_ui_scene.instantiate()
	peeped_card.card = card
	add_child(peeped_card)
	
	# Assign the respective pile_objects based on enum and player conroller
	var mapping = p1_ui_mapping if controller.player == CombatScene.Player.ONE else p2_ui_mapping

	var deck_ui = mapping[CombatCardState.CardTarget.DECK] as PileUI
	
	# Call get_add_location of card from 'to_pile'
	var add_location = deck_ui.get_add_location()
	
	peeped_card.global_position = add_location
	
	await get_tree().create_timer(peep_duration).timeout
	remove_peeped_card()


func remove_peeped_card() -> void:
	if peeped_card:
		#TODO: animation
		peeped_card.queue_free()
		peeped_card = null


func move_card_with_animation(controller: PlayerController, card: CombatCard, from_pile: CombatCardState.CardTarget, to_pile: CombatCardState.CardTarget):
	remove_peeped_card()
	#print('move_card_with_animation')
	# Instantiate card ui for tween
	var temp_card = card_ui_scene.instantiate()
	temp_card.card = card
	add_child(temp_card)
	
	# Assign the respective pile_objects based on enum and player conroller
	var mapping = p1_ui_mapping if controller.player == CombatScene.Player.ONE else p2_ui_mapping
	var from_pile_ui = mapping[from_pile] as PileUI
	var to_pile_ui = mapping[to_pile] as PileUI
	
	# Call remove_card on 'from_pile'
	from_pile_ui.remove_card(card)
	
	# Call get_remove_location of card from 'from_pile'
	var remove_location = from_pile_ui.get_remove_location(card)
	temp_card.global_position = remove_location
	#print('remove_location: ', remove_location)
	
	# Call get_add_location of card from 'to_pile'
	var add_location = to_pile_ui.get_add_location()
	#print('add_location: ', add_location)
	
	# Tween between those two locations
	var tween = get_tree().create_tween()
	tween.tween_property(temp_card, "global_position", add_location, 0.5)

	# After animation, remove temp card and update UI
	await tween.finished
	temp_card.queue_free()

	# Call add_card on 'to_pile'
	to_pile_ui.add_card(card)
	
	
func add_card_with_animation(controller: PlayerController, card: CombatCard, to_pile: CombatCardState.CardTarget, source: Node):
	remove_peeped_card()
	# Instantiate card ui for tween
	var temp_card = card_ui_scene.instantiate()
	temp_card.card = card
	add_child(temp_card)
	
	# Assign the respective pile_objects based on enum and player conroller
	var mapping = p1_ui_mapping if controller.player == CombatScene.Player.ONE else p2_ui_mapping
	var to_pile_ui = mapping[to_pile] as PileUI
	 
	temp_card.global_position = source.global_position
	
	# Call get_add_location of card from 'to_pile'
	var add_location = to_pile_ui.get_add_location()
	
	# Tween between those two locations
	var tween = get_tree().create_tween()
	tween.tween_property(temp_card, "global_position", add_location, 0.5)

	# After animation, remove temp card and update UI
	await tween.finished
	temp_card.queue_free()

	# Call add_card on 'to_pile'
	to_pile_ui.add_card(card)
	
	
func setup_ui_mapping(
	p1_deck_ui: PileUI, 
	p1_discard_ui: PileUI,
	p1_graveyard_ui: PileUI,
	p1_hand_ui: PileUI,
	p1_void_ui: PileUI,
	p2_deck_ui: PileUI, 
	p2_discard_ui: PileUI,
	p2_graveyard_ui: PileUI,
	p2_hand_ui: PileUI,
	p2_void_ui: PileUI, #not sure if void will be pile UI but whatever
	) -> void:
	
	p1_ui_mapping = {
		CombatCardState.CardTarget.DECK: p1_deck_ui,
		CombatCardState.CardTarget.DISCARD: p1_discard_ui,
		CombatCardState.CardTarget.GRAVEYARD: p1_graveyard_ui,
		CombatCardState.CardTarget.HAND: p1_hand_ui,
		CombatCardState.CardTarget.VOID: p1_void_ui
	}
	p2_ui_mapping = {
		CombatCardState.CardTarget.DECK: p2_deck_ui,
		CombatCardState.CardTarget.DISCARD: p2_discard_ui,
		CombatCardState.CardTarget.GRAVEYARD: p2_graveyard_ui,
		CombatCardState.CardTarget.HAND: p2_hand_ui,
		CombatCardState.CardTarget.VOID: p2_void_ui
	}
