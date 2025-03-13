class_name Guard
extends Ability


const NAME = "Guard"
const DESC = "When this card wins defense, it gains endure."


func get_name() -> String:
	return NAME

	
func get_description() -> String:
	return DESC


func on_defend_succedes(
	cur_card: CombatCard, 
	cur_controller: PlayerController, 
	opp_controller: PlayerController) -> void:
	var endure = Endure.new()
	cur_card.add_ability(endure)
	cur_controller.combat_log.log_event(cur_card.get_card_name() + ' gains ENDURE via GUARD')
	await cur_controller.get_tree().create_timer(PROCESS_TIME).timeout
