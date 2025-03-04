class_name CardUI
extends Control

var card: CombatCard

@onready var card_name_label = %CardNameLabel
@onready var probability_label = %ProbabilityLabel
@onready var description_label = %DescriptionLabel


func _ready() -> void:
	if card:
		setup()


func setup() -> void:
	card_name_label.text = card.get_card_name()
	probability_label.text = str(card.get_probability() * 100).pad_decimals(0) + '%'
	description_label.text = card.get_card_description()
	
