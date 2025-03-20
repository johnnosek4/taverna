class_name CardUI
extends Control

var card: CombatCard

@onready var card_name_label = %CardNameLabel
@onready var fate_cost_label: Label = %FateCostLabel
@onready var abilities_container: HFlowContainer = %AbilitiesContainer
@onready var card_type_label: Label = %CardTypeLabel
@onready var description_label = %DescriptionLabel
@onready var color_rect: ColorRect = %ColorRect


func _ready() -> void:
	if card:
		update()


func update() -> void:
	card_name_label.text = card.get_card_name()
	fate_cost_label.text = str(card.get_fate_cost())
	card_type_label.text = CombatCard.Type.keys()[card.get_card_type()]
	#power_toughness_label.text = str(card.get_power()) + ' / ' + str(card.get_toughness())
	description_label.text = card.get_card_description()
	#update_abilities_container()
	

#func update_abilities_container() -> void:
	#for child in abilities_container.get_children():
		#child.queue_free()
	#for ability in card.get_abilities():
		#var ability_tag = Label.new()
		#ability_tag.add_theme_font_size_override('font_size',24)
		#ability_tag.text = ability.get_name()
		#ability_tag.tooltip_text = ability.get_description()
		#abilities_container.add_child(ability_tag)
		#ability_tag.mouse_filter = Control.MOUSE_FILTER_STOP


func select() -> void:
	color_rect.color = Color.GREEN


func deselect() -> void:
	color_rect.color = Color('373737a8')
	

	
