class_name HandStatsUI
extends Panel

var combat_cards: CombatCardState

@onready var fate_label: Label = %FateLabel
@onready var attack_label: Label = %PowerLabel
@onready var defense_label: Label = %ToughnessLabel


func update() -> void:
	fate_label.text = 'Fate: ' + str(combat_cards.hand_fate)
	attack_label.text = 'Attack: ' + str(combat_cards.hand_attack)
	defense_label.text = 'Defense: ' + str(combat_cards.hand_defense)
