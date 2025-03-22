class_name Gestalt
extends CombatCard


const NAME = "Gestalt"
const DESC = "Add attack equal to the sum of attacks of all other cards in hand"


func _init() -> void:
	_id = "012"
	_base_fate_cost = 0.1
	_card_type = Type.OFFENSIVE


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


# NOTE: this will break if we do this for any other card as it will
# create an infinite loop.  Could also use the hand_stats variable if we had
# access to that.
func get_attack(hand: Array[CombatCard]) -> int:
	var hand_attack: int = 0
	for card in hand:
		if not card.get_card_name() == NAME:
			hand_attack += card.get_attack(hand)
	return hand_attack


func get_copy() -> Gestalt:
	return Gestalt.new()
