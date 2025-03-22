class_name PlayerCollection
extends Resource

@export var player_name: String = "TEST"
@export var unlocked_cards: Array[String] # Array of card IDs
@export var decks: Dictionary # Deck ID to Deck resource

const SAVE_PATH = "user://player_collection.tres"

func add_card(card_id: String) -> void:
	if not card_id in unlocked_cards:
		unlocked_cards.append(card_id)


func create_deck(name: String) -> String:
	var new_deck = Deck.new()
	new_deck.id = generate_unique_id()
	new_deck.name = name
	new_deck.creation_date = Time.get_unix_time_from_system()
	new_deck.last_modified = new_deck.creation_date
	
	decks[new_deck.id] = new_deck
	save_collection()
	return new_deck.id


func delete_deck(deck_id: String) -> bool:
	if decks.has(deck_id):
		decks.erase(deck_id)
		save_collection()
		return true
	return false


func save_collection() -> void:
	var save_path = SAVE_PATH
	#var save_path = SAVE_PATH + player_name + '.tres'
	ResourceSaver.save(self, save_path)


func load_collection() -> bool:
	var save_path = SAVE_PATH + player_name + '.tres'
	#var save_path = SAVE_PATH + player_name + '.tres'
	if FileAccess.file_exists(save_path):
		var loaded = ResourceLoader.load(save_path)
		if loaded:
			unlocked_cards = loaded.unlocked_cards
			decks = loaded.decks
			return true
	return false


func generate_unique_id() -> String:
	return str(randi() % 1000000).pad_zeros(6)
