class_name Feaster
extends CombatCard

'''
DEV NOTES 2.0
Test card
'''

const NAME = "Feaster"

func _init() -> void:
	_base_power = 1
	_base_toughness = 1
	_base_abilities = [Feed.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return "hungry...hungry all the time"


func get_copy() -> Feaster:
	return Feaster.new()
