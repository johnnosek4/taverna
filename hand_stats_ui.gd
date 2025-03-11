class_name HandStatsUI
extends Panel

var combat_cards: CombatCardState

@onready var fate_label: Label = %FateLabel
@onready var power_label: Label = %PowerLabel
@onready var toughness_label: Label = %ToughnessLabel


func update() -> void:
	fate_label.text = 'Fate: ' + str(combat_cards.hand_fate)
	power_label.text = 'Power: ' + str(combat_cards.hand_power)
	toughness_label.text = 'Toughness: ' + str(combat_cards.hand_toughness)
