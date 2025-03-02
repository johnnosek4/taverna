class_name HumanController
extends PlayerController


func _input(event):
	#print("input event received: ", event)
	if controllers_turn:  # Only current player can take action
		#SO, player controller can manipulate the state that it controls
		#(still need to make sure that the UI is getting updated as combat card state gets updated)
		#And THEN, when roll is selected, that ends the player turn
		#and the combat_handler processes the actual state of the cards
		if event.is_action_pressed("draw"):
			print('draw event was pressed')
			combat_cards.draw_card()
		elif event.is_action_pressed("roll"):
			print('roll event was pressed')
			end_turn()

