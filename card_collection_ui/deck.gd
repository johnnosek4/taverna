class_name Deck
extends Resource

@export var id: String
@export var name: String
@export var cards: Dictionary # card_id/card_count
@export var creation_date: int
@export var last_modified: int

func add_card(card_id: String) -> bool:
	cards[card_id] = cards.get_or_add(card_id, 0) + 1
	last_modified = Time.get_unix_time_from_system()
	return true
	
func remove_card(card_id: String) -> bool:
	if card_id in cards:
		if cards[card_id] == 1:
			cards.erase(card_id)
		else:
			cards[card_id] -= 1
		last_modified = Time.get_unix_time_from_system()
		return true
	return false


func get_count() -> int:
	var count: int = 0
	for card in cards:
		count += cards[card]
	return count
	
	
#func to_dict() -> Dictionary:
	#return {
		#"id": id,
		#"name": name,
		#"cards": cards,
		#"creation_date": creation_date,
		#"last_modified": last_modified
	#}
