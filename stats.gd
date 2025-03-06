class_name Stats
extends RefCounted

enum PlayerType {HUMAN, AI}

signal stats_changed
signal dead(stats: Stats)

'''
base class for both the player and any AI opponents
'''

#enum Effect {
	#VULNERABLE,
	#PROTECTED,
	#DEADLY,
	#WEAK,
	#FOCUSED,
	#DISTRACTED,
#}

var name: String = "Flub"
var player_type: PlayerType = PlayerType.HUMAN
var logger: CombatLog
var current_health: int = 40: set = set_current_health
var max_health: int = 40
var card_pile: Dictionary = {}: set = _on_card_pile_update #Dictionary of cards w/ key/value being card/card_count_of_deck
var deck: Array = [CombatCard] #Array of Cards
var effects: Array[Effect] = []
#var effects: Dictionary = {} #Effect/Count key/value

var vulnerable_base_mult: float = 1.5
var protected_base_mult: float = 0.66


func apply_damage(dmg: int) -> void:
	var dmg_taken = dmg
	for effect in effects:
		dmg_taken = effect.modify_damage_taken(dmg_taken)
	#logger.log_event(name + ' takes ' + str(dmg_taken) + ' damage!')
	current_health -= roundi(dmg_taken)
	

func modify_damage_dealt(dmg: int) -> int:
	var dmg_dealt = dmg
	for effect in effects:
		dmg_dealt = effect.modify_damage_dealt(dmg_dealt)
	return dmg_dealt
	


func update_effect_durations() -> void:
	#var deletion_queue = []
	#for effect in effects:
		#if 'duration' in effect:
			#effect.duration -= 1
			#if effect.duration == 0:
				#deletion_queue.append(effect)
	#for i in range(deletion_queue.size() - 1, -1, -1):
		#deletion_queue[i].queue_free()
		
	for i in range(effects.size() - 1, -1, -1):
		var effect = effects[i]
		print('effects list length: ' + str(len(effects)))
		if 'duration' in effect:
			effect.duration -= 1
			print('UPDATED effect duration: ' + effect.get_name() + ' duration: ' + str(effect.duration))
			if effect.duration == 0:
				print('removing effect: ' + effect.get_name())
				effects.remove_at(i)
				print('updated effects list length: ' + str(len(effects)))
	stats_changed.emit()


func set_current_health(value: int) -> void:
	if value > 0:
		current_health = value
	else:
		current_health = 0
		dead.emit(self)
		print('DEAD')
	stats_changed.emit()


func add_effect(effect: Effect) -> void:
	effects.append(effect)
	print('effect added: ', effect.get_name())
	stats_changed.emit()

#func add_effect(effect: Effect) -> void:
	#if effects.get(effect):
		#effects[effect] = effects[effect] + 1
	#else:
		#effects[effect] = 1
	#stats_changed.emit()
#
#
#func remove_effect(effect: Effect) -> void:
	#if effects.get(effect):
		#if effects[effect] > 1:
			#effects[effect] = effects[effect] - 1
		#else:
			#effects.erase(effect)
		#stats_changed.emit()
	#else:
		#print('effect does not exist on player')
		#
#
func clear_effects() -> void:
	effects = []
	stats_changed.emit()
	

func _on_card_pile_update(value) -> void:
	card_pile = value
	deck = construct_deck_from_pile(card_pile)


static func construct_deck_from_pile(card_pile: Dictionary) -> Array[CombatCard]:
	var new_deck: Array[CombatCard] = []
	for card in card_pile:
		for i in range(card_pile[card]):
			var copy = card.get_copy()
			new_deck.append(copy)
	return new_deck
			
	
