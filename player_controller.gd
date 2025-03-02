class_name PlayerController
extends Node

var stats: Stats
var combat_cards: CombatCardState
var ui: PlayerUI
var controllers_turn: bool = false
var on_turn_ended: Callable

func start_turn() -> void:
	print('start turn for: ' + stats.name)
	#Adding in this timer because I suspect the 'roll' event input is causing issues by 'lasting too long'
	#and getting called even after the controller switchover
	await get_tree().create_timer(0.5).timeout
	controllers_turn = true

func end_turn() -> void:
	controllers_turn = false
	print('end turn for: ' + stats.name)
	on_turn_ended.call()
	

