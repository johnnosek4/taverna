class_name CombatStats
extends Resource

@export_range(0, 2) var battle_tier: int
@export_range(0.0, 10.0) var weight: float
@export var gold_reward_min: int
@export var gold_reward_max: int
@export var opp_stats: Stats
@export var opp_temperament: AIController.Temperament
@export var opp_deck: Deck

var accumulated_weight: float = 0.0

#TODO: implement RNG seed saving
#func roll_gold_reward() -> int:
	#return RNG.instance.randi_range(gold_reward_min, gold_reward_max)
