class_name CardDatabase
extends Node


var cards: Array[CombatCard]


func _ready():
	init_all_cards()


func init_all_cards():
	cards = [
	Strike.new(),
	Salve.new(),
	GreaterSalve.new(),
	Posturing.new(),
	Vainglory.new(),
	Gestalt.new(),
	Turtle.new(),
	Block.new(),
	Riposte.new(),
	Deadly.new(),
	Noxious.new(),
	Finisher.new(),
	Swarm.new(),
	Trojka.new(),
	Balance.new(),
	Bloodlust.new(),
	Fortify.new(),
	ChokePoint.new(),
	Forged.new(),
	Flank.new(),
	Gambit.new(),
	Pyrrhic.new(),
	Harbinger.new(),
	Martyr.new(),
	
	#Feint.new(), #NOTE: commented out for now while i decide what to do with status effects
	]


func get_card(card_id: String) -> CombatCard:
	for card in cards:
		if card.get_id() == card_id:
			return card.get_copy()
	return null
	

func get_all_ids() -> Array[String]:
	var ids: Array[String] = []
	for card in cards:
		ids.append(card.get_id())
	return ids
