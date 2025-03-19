class_name HandStatsUI
extends Panel

var combat_cards: CombatCardState

@onready var fate_label: Label = %FateLabel
@onready var base_attack: Label = %BaseAttack
@onready var attack_mult: Label = %AttackMult
@onready var attack: Label = %Attack
@onready var base_defense: Label = %BaseDefense
@onready var defense_mult: Label = %DefenseMult
@onready var defense: Label = %Defense


func update() -> void:
	fate_label.text = 'Fate: ' + str(combat_cards.hand_fate)
	base_attack.text = 'Base: ' + str(combat_cards.hand_base_attack)
	base_defense.text = 'Base: ' + str(combat_cards.hand_base_defense)
	attack_mult.text = 'Mult: ' + str(combat_cards.hand_attack_mult).pad_decimals(1)
	defense_mult.text = 'Mult: ' + str(combat_cards.hand_defense_mult).pad_decimals(1)
	attack.text = 'Total: ' + str(combat_cards.hand_attack) 
	defense.text = 'Total: '+ str(combat_cards.hand_defense)
