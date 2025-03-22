class_name Card
extends Resource

@export var id: String
@export var name: String
@export var description: String
@export var image_path: String
@export var card_type: String
@export var rarity: String
@export var attributes: Dictionary

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"image_path": image_path,
		"card_type": card_type,
		"rarity": rarity,
		"attributes": attributes
	}
