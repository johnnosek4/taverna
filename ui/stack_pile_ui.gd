class_name StackPileUI
extends PileUI

'''
Dev Note: intentionally keeping add/remove/location methods in order
to share a single interface with spreadPileUI, so the card animator
can do its thing regardless of type

Further down the line, we could add a 'stack effect' to make it actually
look like a pile
'''

var card_pile: Array[CombatCard]

@export var pile_name: String = 'NOT IMPLEMENTED'
@export var show_count: bool = true

@onready var card_count = %CardCount
@onready var pile_name_label: Label = %PileName


func _ready() -> void:
	pile_name_label.text = pile_name
	card_count.visible = show_count


func update() -> void:
	#TODO: can make cooler effects here for stack pile
	card_count.text = str(len(card_pile))
	var names = []
	for card in card_pile:
		names.append(card.get_card_name())
	tooltip_text = ', '.join(names)


func add_card(_card: CombatCard) -> void:
	update()
	

func remove_card(_card: CombatCard) -> void:
	update()

		
func get_add_location() -> Vector2:
	return global_position


func get_remove_location(card: CombatCard) -> Vector2:
	return global_position


#func _make_custom_tooltip(for_text):
	#var tooltip = Label.new()
	#tooltip.text = for_text
	#tooltip.autowrap_mode = TextServer.AUTOWRAP_WORD  # Enable word wrap
	#tooltip.set_size(Vector2(200, 0))  # Set max width (height auto-adjusts)
	#return tooltip
