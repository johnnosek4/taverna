class_name SpiderFangMail
extends CombatCard


const NAME = "Spider Fang Mail"
const DESC = "..."


func _init() -> void:
	_base_power = 1
	_base_toughness = 3
	_base_abilities = [Venom.new(), Guard.new()]
	super._init()


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


func get_copy() -> SpiderFangMail:
	return SpiderFangMail.new()
