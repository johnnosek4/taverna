extends MarginContainer

var combat_card: CombatCard
var card_count: int: set = _update_count_label

@onready var increase_count: Button = %IncreaseCount
@onready var count_label: Label = %CountLabel
@onready var decrease_count: Button = %DecreaseCount
@onready var card_ui: CardUI = %CardUI


func _ready() -> void:
	card_ui.card = combat_card
	card_ui.setup()
	count_label.text = str(card_count)
	increase_count.pressed.connect(increment_count)
	decrease_count.pressed.connect(decrement_count)
	
	
func _update_count_label(value) -> void:
	if value < 0:
		card_count = 0
	else:
		card_count = value
	if count_label:
		count_label.text = str(card_count)


func increment_count() -> void:
	card_count += 1
	
	
func decrement_count() -> void:
	card_count -= 1
	
