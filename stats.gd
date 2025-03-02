class_name Stats
extends RefCounted

enum PlayerType {HUMAN, AI}

signal stats_changed
signal dead(stats: Stats)

'''
base class for both the player and any AI opponents
'''

enum Effect {
	VULNERABLE,
	PROTECTED,
	DEADLY,
	WEAK,
	FOCUSED,
	DISTRACTED,
}

var name: String = "Flub"
var player_type: PlayerType = PlayerType.HUMAN
var current_health: int = 40: set = set_current_health
var max_health: int = 40
var card_pile: Array = [] #Array of Cards
var deck: Array = [] #Array of Cards
var effects: Dictionary = {} #Effect/Count key/value


func apply_damage(dmg: int) -> void:
	var vulnerable_count = effects.get


func set_current_health(value: int) -> void:
	current_health = value
	if value <=0 :
		dead.emit(self)
		print('DEAD')
	stats_changed.emit()
	

func add_effect(effect: Effect) -> void:
	if effects.get(effect):
		effects[effect] = effects[effect] + 1
	else:
		effects[effect] = 1
	stats_changed.emit()


func remove_effect(effect: Effect) -> void:
	if effects.get(effect):
		if effects[effect] > 1:
			effects[effect] = effects[effect] - 1
		else:
			effects.erase(effect)
		stats_changed.emit()
	else:
		print('effect does not exist on player')
	

