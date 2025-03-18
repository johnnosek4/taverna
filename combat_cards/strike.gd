class_name Strike
extends CombatCard


const NAME = "Strike"
const DESC = "Add 5 Attack"


func _init() -> void:
	_base_attack = 5
	#_base_absorb = 0
	#_base_damage_mult = 1.0
	#_base_absorb_mult = 1.0


func get_card_name() -> String:
	return NAME


func get_card_description() -> String:
	return DESC


#func get_damage() -> int:
	#return _base_damage


#func get_absorb() -> int:
	#return _base_absorb
	#
#
#func get_damage_mult() -> float:
	#return _base_damage_mult
#
#
#func get_absorb_mult() -> float:
	#return _base_absorb_mult


func get_copy() -> Strike:
	return Strike.new()


func on_action_succedes(cur_controller: PlayerController, opp_controller: PlayerController) -> void:
	pass
	#var dmg_dealt = cur_controller.stats.modify_damage_dealt(get_attack())
	#opp_controller.stats.apply_damage(dmg_dealt)
	#combat_ui_manager.log.log_event(cur_controller.stats.name + ' executes a strike for ' + str(dmg_dealt) + ' damage!')
