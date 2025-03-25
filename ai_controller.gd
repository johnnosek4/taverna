class_name AIController
extends RefCounted

const THINK_TIME: float = 1.6

# Reference to the controller that provides game state and executes commands
var _controller: PlayerController
var _opp_controller: PlayerController

# Configuration parameters to tweak AI behavior
#var aggression_factor: float = 0.6  # Higher values make AI more aggressive
#var defense_threshold: float = 0.3   # Health percentage at which AI becomes more defensive

#var base_min_max_draw_amts: Array[int] = [0, 5]
#var base_min_max_draw_likelihoods: Array[float] = [1.0, 0.25]
var deal_dmg_weighting: float = 0.5
var avoid_dmg_weighting: float = 0.5
var min_fate_tolerance: float = 0.5
var draw_count: int = 0
var opp_attacks: Array[int]
var opp_defenses: Array[int]

# AI Temperament type
enum Temperament {BALANCED, AGGRESSIVE, DEFENSIVE, CHAOTIC}
var _temperament := Temperament.BALANCED


func _init(

	#controller: PlayerController, 
	#opp_controller: PlayerController,
	temperament = Temperament.DEFENSIVE):
	opp_attacks = []
	opp_defenses = []
	#_controller = controller
	#_opp_controller = opp_controller
	_temperament = temperament
	# Apply Temperament-specific configurations

func regenerate_temperament_vars():
	# Adjust behavior parameters based on Temperament
	match _temperament:
		Temperament.BALANCED:
			#base_min_max_draw_amts = [1, randi_range(5,7)]
			#base_min_max_draw_likelihoods = [1.0, 0.4]
			deal_dmg_weighting = randf_range(0.4, 0.6)
			avoid_dmg_weighting = 1.0 - deal_dmg_weighting
			min_fate_tolerance = randf_range(0.4, 0.6)
		Temperament.AGGRESSIVE:
			#base_min_max_draw_amts = [2, randi_range(6,8)]
			#base_min_max_draw_likelihoods = [1.0, 0.4]
			deal_dmg_weighting = randf_range(0.6, 0.9)
			avoid_dmg_weighting = 1.0 - deal_dmg_weighting
			min_fate_tolerance = randf_range(0.1, 0.5)
		Temperament.DEFENSIVE:
			#base_min_max_draw_amts = [1, randi_range(5,7)]
			#base_min_max_draw_likelihoods = [1.0, 0.4]
			deal_dmg_weighting = randf_range(0.1, 0.4)
			avoid_dmg_weighting = 1.0 - deal_dmg_weighting
			min_fate_tolerance = randf_range(0.5, 0.6)
		Temperament.CHAOTIC:
			#base_min_max_draw_amts = [1, randi_range(5,9)]
			#base_min_max_draw_likelihoods = [1.0, 0.4]
			deal_dmg_weighting = randf_range(0.1, 0.9)
			avoid_dmg_weighting = 1.0 - deal_dmg_weighting
			min_fate_tolerance = randf_range(0.2, 0.4)


func start_setup() -> void:
	print('AI: START SETUP')
	draw_count = 0
	regenerate_temperament_vars()
	print('AI: TEMPERAMENT VARS: ', Temperament.keys()[_temperament])
	#print('AI: base_min_max_draw_amts: ', base_min_max_draw_amts)
	#print('AI: base_min_max_draw_likelihoods: ', base_min_max_draw_likelihoods)
	print('AI: deal_dmg_weighting: ', deal_dmg_weighting)
	print('AI: avoid_dmg_weighting: ', avoid_dmg_weighting)
	print('AI: min_fate_tolerance: ', min_fate_tolerance)
	
	take_turn()
	

func take_turn() -> void:
	print('AI: TAKE TURN')
	print('AI: draw_count: ', draw_count)

	await _controller.get_tree().create_timer(THINK_TIME).timeout
	# Main decision-making function that runs each AI turn
	
	# Get current game state
	var cur_health = _controller.stats.current_health
	var max_health = _controller.stats.max_health
	var opp_cur_health = _opp_controller.stats.current_health
	var opp_max_health = _opp_controller.stats.max_health
	var attack = _controller.combat_cards.hand_attack
	var defense = _controller.combat_cards.hand_defense
	var opp_attack = _opp_controller.combat_cards.hand_attack
	var opp_defense = _opp_controller.combat_cards.hand_defense
	var fate = _controller.combat_cards.hand_fate
	var opp_fate = _opp_controller.combat_cards.hand_fate
	var is_attacker = _controller.is_attacker
	
	# Calculate some derived values for decision making
	#var health_percentage = health / _controller.stats.max_health
	#var opp_health_percentage = opp_health / _opp_controller.stats.max_health
	#var expected_damage_to_deal = (attack * fate) - (opp_defense * opp_fate)
	#var expected_damage_to_receive = (opp_attack * opp_fate) - (defense * fate)
	
	# Analyze the deck for making informed decisions
	var card_type_probabilities = analyze_deck()
	
	# Make decisions based on game state and deck analysis
	var should_draw = decide_draw_card(
		cur_health,
		max_health,
		opp_cur_health,
		opp_max_health,
		attack,
		defense,
		fate,
		opp_attack,
		opp_defense,
		opp_fate,
		is_attacker,
		card_type_probabilities
	)
	
	# Execute the chosen action
	if should_draw:
		draw_count += 1
		_controller.draw_card()
		# After drawing, recalculate and potentially decide again
		# This is recursive but will end when the AI decides to end turn
		take_turn()
	else:
		_controller.end_setup()


func store_combat_data(opp_attack: int, opp_defense: int) -> void:
	opp_attacks.append(opp_attack)
	opp_defenses.append(opp_defense)
	

func analyze_deck():
	# Analyze the deck to calculate probabilities of drawing each type of card
	
	# Get deck information from controller
	var deck = _controller.combat_cards.deck
	var discard_pile = _controller.combat_cards.discard_pile
	var graveyard_pile = _controller.combat_cards.graveyard_pile
	var hand = _controller.combat_cards.hand
	
	# Get the total deck composition (all cards including those in play)
	var total_offensive_cards: int = 0
	var total_defensive_cards: int = 0
	var total_chaotic_cards: int = 0
	
	# Count cards by type in the discard pile and hand
	var offensive_cards_seen = 0
	var defensive_cards_seen = 0
	var chaotic_cards_seen = 0
	
	# Count in deck
	for card in deck:
		match card.get_card_type():
			CombatCard.Type.OFFENSIVE: total_offensive_cards += 1
			CombatCard.Type.DEFENSIVE: total_defensive_cards += 1
			CombatCard.Type.CHAOTIC: total_chaotic_cards += 1
	
	# Count in discard pile
	for card in discard_pile:
		match card.get_card_type():
			CombatCard.Type.OFFENSIVE: 
				total_offensive_cards += 1
				offensive_cards_seen += 1
			CombatCard.Type.DEFENSIVE: 
				total_defensive_cards += 1
				defensive_cards_seen += 1
			CombatCard.Type.CHAOTIC:
				total_chaotic_cards += 1
				chaotic_cards_seen += 1
	
	# Count in Hand
	for card in discard_pile:
		match card.get_card_type():
			CombatCard.Type.OFFENSIVE: 
				total_offensive_cards += 1
				offensive_cards_seen += 1
			CombatCard.Type.DEFENSIVE: 
				total_defensive_cards += 1
				defensive_cards_seen += 1
			CombatCard.Type.CHAOTIC:
				total_chaotic_cards += 1
				chaotic_cards_seen += 1
				
		# Count in discard pile
	for card in graveyard_pile:
		match card.get_card_type():
			CombatCard.Type.OFFENSIVE: 
				total_offensive_cards += 1
				offensive_cards_seen += 1
			CombatCard.Type.DEFENSIVE: 
				total_defensive_cards += 1
				defensive_cards_seen += 1
			CombatCard.Type.CHAOTIC:
				total_chaotic_cards += 1
				chaotic_cards_seen += 1
	
	# Calculate remaining cards in deck by type
	var offensive_cards_remaining = total_offensive_cards - offensive_cards_seen
	var defensive_cards_remaining = total_defensive_cards - defensive_cards_seen
	var chaotic_cards_remaining = total_chaotic_cards - chaotic_cards_seen
	var total_cards_remaining = deck.size()
	
	# Calculate probabilities
	var probability = {
		CombatCard.Type.OFFENSIVE: float(offensive_cards_remaining) / total_cards_remaining if total_cards_remaining > 0 else 0,
		CombatCard.Type.DEFENSIVE: float(defensive_cards_remaining) / total_cards_remaining if total_cards_remaining > 0 else 0,
		CombatCard.Type.CHAOTIC: float(chaotic_cards_remaining) / total_cards_remaining if total_cards_remaining > 0 else 0
	}
	
	return probability


func decide_draw_card(
	cur_health: int, 
	max_health: int, 
	opp_cur_health: int,
	opp_max_health: int,
	attack: int, 
	defense: int, 
	fate: float,
	opp_attack: int,
	opp_defense: int,
	opp_fate: float,
	is_attacker: bool, 
	card_type_probabilities: Dictionary) -> bool:
	# Always draw the first card
	if draw_count <= 1:
		print('AI: draw_count <= 1, draw again')
		return true
	
	# Might as well keep going if we got nothing to lose
	# Could be instances where this isnt the case but those would be edge cases to look at further out
	if attack == 0 and defense == 0:
		print('AI: Atack/Defense = 0/0, draw again')
		return true
	
	# TODO: Implement all special cases once cards are known.  E.g. finisher, troijka, etc
	
	# Check Draw for attack reasons	
	var prob_to_draw_for_attack_reasons = calc_prob_to_draw_for_attack_reasons(
		cur_health,
		max_health,
		opp_cur_health,
		opp_max_health,
		attack,
		defense,
		fate,
		opp_attack,
		opp_defense,
		opp_fate,
		is_attacker,
		card_type_probabilities,
	)
	
	var attack_probability_roll = randf()
	print('AI: attack_probability_roll: ', attack_probability_roll)
	if attack_probability_roll > (1 - prob_to_draw_for_attack_reasons) and fate >= min_fate_tolerance:
		print('AI: DRAWING for attack reasons')
		return true
		
	# Check Draw for Defense reasons	
	var prob_to_draw_for_defense_reasons = calc_prob_to_draw_for_defense_reasons(
		cur_health,
		max_health,
		opp_cur_health,
		opp_max_health,
		attack,
		defense,
		fate,
		opp_attack,
		opp_defense,
		opp_fate,
		is_attacker,
		card_type_probabilities,
	)
	
	var defense_probability_roll = randf()
	print('AI: attack_probability_roll: ', attack_probability_roll)
	if defense_probability_roll > (1 - prob_to_draw_for_defense_reasons) and fate >= min_fate_tolerance:
		print('AI: DRAWING for defense reasons')
		return true

	return false


func get_average(arr: Array) -> float:
	if arr.is_empty():
		return 0.0  # Avoid division by zero
	var total := 0.0
	for value in arr:
		total += value
	return total / arr.size()


func calc_prob_to_draw_for_attack_reasons(
	cur_health: int,
	max_health: int, 
	opp_cur_health: int,
	opp_max_health: int,
	attack: int, 
	defense: int, 
	fate: float,
	opp_attack: int,
	opp_defense: int,
	opp_fate: float,
	is_attacker: bool, 
	card_probabilities: Dictionary) -> float:
	print('AI: calc_prob_to_draw_for_attack_reasons')
	var prob_to_draw_for_attack_reasons: float = 0.0
	
	var _opp_def = opp_defense

	if is_attacker:
		print('AI: is_attacker')
		_opp_def = round(get_average(opp_defenses))
		print('AI: average_opp_defense: ', _opp_def)

	var attack_def_delta = attack - _opp_def
	var attack_def_delta_as_pcnt_opponent_cur_health = float(attack_def_delta) / opp_cur_health
	print('AI: attack: ', attack)
	print('AI: attack_def_delta: ', attack_def_delta)
	print('AI: attack_def_delta_as_pcnt_opponent_cur_health: ', attack_def_delta_as_pcnt_opponent_cur_health)

	# NOTE: adding this to avoid a 1 card/2 attack situation
	# BUT important to note that in defensive decks we may not want to force another card draw
	# So maybe check against temperament?
	# NOTE/TODO: these apply to the attack_def_delta, rather than just attack
	# Makes sense for now as aggressive temperament, but maybe just change it to be
	# based off of just attack
	var min_relative_attack_threshold_aggressive: float = 0.1
	var min_absolute_attack_threshold_aggressive: int = 5
	if _temperament == Temperament.AGGRESSIVE and (attack_def_delta_as_pcnt_opponent_cur_health < min_relative_attack_threshold_aggressive or attack_def_delta < min_absolute_attack_threshold_aggressive):
		print('AI: attack_prob == 1 due to min thresholds')
		return 1.0

	# NOTE: THIS actually seems really good, and intuitive and makes physical sense
	prob_to_draw_for_attack_reasons = (1-attack_def_delta_as_pcnt_opponent_cur_health)
	print('AI: prob_to_draw_for_attack_reasons: ', prob_to_draw_for_attack_reasons)
	
	# What are the chances another card will actually add attack?
	var probability_to_increase_attack_from_draw: float = calc_probability_to_increase_attack(attack, defense, fate, opp_attack, opp_defense, opp_fate, is_attacker, card_probabilities)
	print('AI: probability_to_increase_attack_from_draw: ', probability_to_increase_attack_from_draw)

	# NOTE: less clear on this one: I can see why it makes sense we would maybe not want to draw if the likelihood is low, but we still need to do dmg at some point
	# tho it does kinda make sense in that, if the prob to increase attack from draw = 0, then prob to draw for attack reasons would also go to zero
	prob_to_draw_for_attack_reasons = prob_to_draw_for_attack_reasons * probability_to_increase_attack_from_draw
	print('AI: prob_to_draw_for_attack_reasons: ', prob_to_draw_for_attack_reasons)


	var delta_from_min_fate: float = max(fate - min_fate_tolerance, 0.0)
	var delta_from_min_fate_as_pct: float = delta_from_min_fate / (1.0 - min_fate_tolerance)
	
	# The idea here is that now its just a question of weighing fate against desire to deal dmg
	# Another option is to simply have the dmg weighting = to deal_dmg weight, and then weight the fate per the remiainder, e.g.
	var fate_weighting = 1.0 - deal_dmg_weighting
	#var fate_weighting: float = 0.5
	#var dmg_weighting: float = 0.5
	
	var fate_dmg_weighted_modifier = (fate_weighting * delta_from_min_fate_as_pct) + (deal_dmg_weighting)
	print('AI: fate_dmg_weighted_modifier: ', fate_dmg_weighted_modifier)

	prob_to_draw_for_attack_reasons = prob_to_draw_for_attack_reasons * fate_dmg_weighted_modifier
	print('AI: prob_to_draw_for_attack_reasons: ', prob_to_draw_for_attack_reasons)
	return prob_to_draw_for_attack_reasons
	
	
func calc_prob_to_draw_for_defense_reasons(
	cur_health: int,
	max_health: int, 
	opp_cur_health: int,
	opp_max_health: int,
	attack: int, 
	defense: int, 
	fate: float,
	opp_attack: int,
	opp_defense: int,
	opp_fate: float,
	is_attacker: bool, 
	card_probabilities: Dictionary) -> float:
	print('AI: calc_prob_to_draw_for_defense_reasons')
	var prob_to_draw_for_defense_reasons: float = 0.0
	
	var _opp_attack = opp_attack

	if is_attacker:
		print('AI: is_attacker')
		#defense scalar is a way to 'be more cautious' since the average is just the average, and you don't know what the oppoenent will roll
		var defense_scalar: float = 1.2
		_opp_attack = round(get_average(opp_attacks) * defense_scalar)
		print('AI: average_opp_attack: ', _opp_attack)

	var attack_def_delta = max(_opp_attack - defense, 0.0)
	var attack_def_delta_as_pcnt_cur_health = float(attack_def_delta) / cur_health
	print('AI: defense: ', defense)
	print('AI: def_attack_delta: ', attack_def_delta)
	print('AI: attack_def_delta_as_pcnt_cur_health: ', attack_def_delta_as_pcnt_cur_health)
	
	#TODO: could have these be instance vars and set them via temperament as well
	var min_relative_defense_threshold_defensive: float = 0.10
	var min_absolute_defense_threshold_defensive: int = 10
	if _temperament == Temperament.DEFENSIVE and (attack_def_delta_as_pcnt_cur_health > min_relative_defense_threshold_defensive or attack_def_delta > min_absolute_defense_threshold_defensive):
		print('AI: defend_prob == 1 due to min thresholds')
		return 1.0
	
	#TODO: figure out a better system for this
	#prob_to_draw_for_defense_reasons = 1.0
	prob_to_draw_for_defense_reasons = attack_def_delta_as_pcnt_cur_health
	print('AI: prob_to_draw_for_defense_reasons: ', prob_to_draw_for_defense_reasons)
	
	# What are the chances another card will actually add attack?
	var probability_to_increase_defense_from_draw: float = calc_probability_to_increase_defense(attack, defense, fate, opp_attack, opp_defense, opp_fate, is_attacker, card_probabilities)
	print('AI: probability_to_increase_defense_from_draw: ', probability_to_increase_defense_from_draw)

	# NOTE: less clear on this one: I can see why it makes sense we would maybe not want to draw if the likelihood is low, but we still need to do dmg at some point
	# tho it does kinda make sense in that, if the prob to increase attack from draw = 0, then prob to draw for attack reasons would also go to zero
	prob_to_draw_for_defense_reasons = prob_to_draw_for_defense_reasons * probability_to_increase_defense_from_draw
	print('AI: prob_to_draw_for_defense_reasons: ', prob_to_draw_for_defense_reasons)


	var delta_from_min_fate: float = max(fate - min_fate_tolerance, 0.0)
	var delta_from_min_fate_as_pct: float = delta_from_min_fate / (1.0 - min_fate_tolerance)
	
	#See above
	var fate_weighting = 1.0 - avoid_dmg_weighting
	
	var fate_dmg_weighted_modifier = (fate_weighting * delta_from_min_fate_as_pct) + (avoid_dmg_weighting)
	print('AI: fate_dmg_weighted_modifier: ', fate_dmg_weighted_modifier)

	prob_to_draw_for_defense_reasons = prob_to_draw_for_defense_reasons * fate_dmg_weighted_modifier
	print('AI: prob_to_draw_for_defense_reasons: ', prob_to_draw_for_defense_reasons)
	return prob_to_draw_for_defense_reasons



func calc_probability_to_increase_attack(
	attack: int, 
	defense: int, 
	fate: float,
	opp_attack: int,
	opp_defense: int,
	opp_fate: float,
	is_attacker: bool, 
	card_probabilities: Dictionary) -> float:
	var prob = card_probabilities[CombatCard.Type.OFFENSIVE]
	return prob
	
	
func calc_probability_to_increase_defense(
	attack: int, 
	defense: int, 
	fate: float,
	opp_attack: int,
	opp_defense: int,
	opp_fate: float,
	is_attacker: bool, 
	card_probabilities: Dictionary) -> float:
	var prob = card_probabilities[CombatCard.Type.DEFENSIVE]
	return prob


#func calc_draw_prob(draw_count: int) -> float:
	#var min_amt = base_min_max_draw_amts[0]
	#var max_amt = base_min_max_draw_amts[1]
	#var min_likelihood = base_min_max_draw_likelihoods[0]
	#var max_likelihood = base_min_max_draw_likelihoods[1]
#
	## Clamp draw_amts to stay within bounds
	#var clamped_draw_count = clamp(draw_count, min_amt, max_amt)
#
	## Normalize clamped_draw_amts to a 0-1 range
	#var t = float(clamped_draw_count - min_amt) / float(max_amt - min_amt)
#
	## Interpolate between min_likelihood and max_likelihood
	#return lerp(min_likelihood, max_likelihood, t)


#func decide_draw_card_ARCH(
	#health_percentage: float, 
	#attack: int, 
	#defense: int, 
	#fate: float,
	#opp_attack: int,
	#opp_defense: int,
	#opp_fate: float,
	#is_attacker: bool, 
	#card_probabilities: Dictionary) -> bool:
	## Always draw the first card
	#if draw_count == 0:
		#return true
	#
	## Might as well keep going if we got nothing to lose
	## Could be instances where this isnt the case but those would be edge cases to look at further out
	#if attack == 0 and defense == 0:
		#print('AI: Atack/Defense = 0/0, draw again')
		#return true
		#
	## Check Draw for attack reasons	
	#var prob_to_draw_for_attack_reasons: float = 0.0
	#if is_attacker:
		##This needs to be treated differently, since the attacker doesn't know the other person hand
		##We could have it track all the defense values of each round, and use an average of those to make decisions
		#pass
	#else:
		##Compare against opponents hand
		#if attack < opp_fate:
			#pass
	#
		#
	## Get base likelihood to draw based on number of cards drawn
	#var base_draw_prob = calc_draw_prob(draw_count)
	#print('AI: draw_count: ', draw_count)
	#print('AI: base_draw_prob: ', base_draw_prob)
#
	## Modify draw_probability based on weights
	#var probability_to_increase_attack: float = calc_probability_to_increase_attack(attack, defense, fate, opp_attack, opp_defense, opp_fate, is_attacker, card_probabilities)
	#var probability_to_increase_defense: float = calc_probability_to_increase_defense(attack, defense, fate, opp_attack, opp_defense, opp_fate, is_attacker, card_probabilities)
	#print('AI: prob_to_increase_attack: ', probability_to_increase_attack)
	#print('AI: prob_to_increase_defense: ', probability_to_increase_defense)
	#
	#base_draw_prob = base_draw_prob * ((probability_to_increase_attack * deal_dmg_weighting) + (probability_to_increase_defense * avoid_dmg_weighting))
	#print('AI: base_draw_prob_mod: ', base_draw_prob)
	#
	#
	#
	#
	#var probability_roll = randf()
	#print('AI: probability_roll: ', probability_roll)
	#if base_draw_prob >= (1-probability_roll):
		#return true
	#else: 
		#return false

#func decide_draw_card_old(health_percentage, expected_damage_to_deal, expected_damage_to_receive, is_attacker, card_probabilities):
	#print('AI: DECIDE DRAW')
	## Adjust decision based on Temperament first
	#var temperament_modifier = get_temperament_modifier(is_attacker)
	#print('AI: temperament modifier: ', temperament_modifier)
	#
	## Then factor in the deck composition for smarter decisions
	#var deck_modifier = calculate_deck_modifier(card_probabilities, is_attacker, health_percentage)
	#print('AI: deck modifier: ', deck_modifier)
#
	#var return_value
	## If health is low, become more defensive
	#if health_percentage < defense_threshold:
		#print('AI: should_draw return value: ', return_value)
#
		## In defensive mode, draw card if:
		## 1. We're the attacker and can deal significant damage
		## 2. We're the defender and need to build up defense
		#if is_attacker:
			#return_value = expected_damage_to_deal > expected_damage_to_receive * (1 - aggression_factor * temperament_modifier * deck_modifier)
		#else:
			## Even in defensive mode, consider ending turn if odds of drawing defense cards are low
			#return_value = card_probabilities[CombatCard.Type.DEFENSIVE] > 0.3 || _temperament == Temperament.DEFENSIVE
	#else:
		## In normal/aggressive mode
		#if is_attacker:
			## As attacker, draw if expected damage is good enough
			#return_value = expected_damage_to_deal > expected_damage_to_receive * (1 - aggression_factor * temperament_modifier * deck_modifier * 1.5)
		#else:
			## As defender, maybe end turn earlier to save cards
			#return_value = expected_damage_to_receive < expected_damage_to_deal * 2 * temperament_modifier * deck_modifier
	#print('AI: should_draw return value: ', return_value)
	#return return_value
#
#
#func get_temperament_modifier(is_attacker):
	## Return a modifier based on the AI's Temperament and current role
	#match Temperament:
		#Temperament.BALANCED:
			#return 1.0
		#Temperament.AGGRESSIVE:
			#return 1.3 if is_attacker else 0.8
		#Temperament.DEFENSIVE:
			#return 0.7 if is_attacker else 1.4
		#Temperament.CHAOTIC:
			## Chaotic is unpredictable but with some logic
			#return randf_range(0.8, 1.5)
	#return 1.0
#
#
#func calculate_deck_modifier(card_probabilities, is_attacker, health_percentage):
	## Calculate a modifier based on the probability of drawing useful cards
	#
	#var modifier = 1.0
	#
	#if is_attacker:
		## When attacking, offensive cards are more valuable
		#if card_probabilities[CombatCard.Type.OFFENSIVE] > 0.5:
			#modifier *= 1.2  # More likely to draw if offensive cards are abundant
		#elif card_probabilities[CombatCard.Type.OFFENSIVE] < 0.2:
			#modifier *= 0.8  # Less likely to draw if offensive cards are rare
			#
		## Chaotic cards can be good for attacking too
		#if card_probabilities[CombatCard.Type.CHAOTIC] > 0.4:
			#modifier *= 1.1
	#else:
		## When defending, defensive cards are more valuable
		#if card_probabilities[CombatCard.Type.DEFENSIVE] > 0.5:
			#modifier *= 1.3  # More likely to draw if defensive cards are abundant
		#elif card_probabilities[CombatCard.Type.DEFENSIVE] < 0.2:
			#modifier *= 0.7  # Less likely to draw if defensive cards are rare
			#
		## At low health, strongly prefer drawing if defensive cards are available
		#if health_percentage < defense_threshold && card_probabilities[CombatCard.Type.DEFENSIVE] > 0.3:
			#modifier *= 1.5
	#
	## Special case for chaotic Temperament
	#if _temperament == Temperament.CHAOTIC && card_probabilities[CombatCard.Type.CHAOTIC] > 0.3:
		#modifier *= 1.2  # Chaotic AI loves chaotic cards!
	#
	#return modifier
	#
	
	
	
	
	
	
	
	
	
	
	


#CHATGPT
#func decide_draw_card_old(health_percentage, expected_damage_to_deal, expected_damage_to_receive, is_attacker, card_probabilities):
	#print('AI: DECIDE DRAW')
	## Adjust decision based on Temperament first
	#var temperament_modifier = get_temperament_modifier(is_attacker)
	#print('AI: temperament modifier: ', temperament_modifier)
	#
	## Then factor in the deck composition for smarter decisions
	#var deck_modifier = calculate_deck_modifier(card_probabilities, is_attacker, health_percentage)
	#print('AI: deck modifier: ', deck_modifier)
#
	#var return_value
	## If health is low, become more defensive
	#if health_percentage < defense_threshold:
		#print('AI: should_draw return value: ', return_value)
#
		## In defensive mode, draw card if:
		## 1. We're the attacker and can deal significant damage
		## 2. We're the defender and need to build up defense
		#if is_attacker:
			#return_value = expected_damage_to_deal > expected_damage_to_receive * (1 - aggression_factor * temperament_modifier * deck_modifier)
		#else:
			## Even in defensive mode, consider ending turn if odds of drawing defense cards are low
			#return_value = card_probabilities[CombatCard.Type.DEFENSIVE] > 0.3 || _temperament == Temperament.DEFENSIVE
	#else:
		## In normal/aggressive mode
		#if is_attacker:
			## As attacker, draw if expected damage is good enough
			#return_value = expected_damage_to_deal > expected_damage_to_receive * (1 - aggression_factor * temperament_modifier * deck_modifier * 1.5)
		#else:
			## As defender, maybe end turn earlier to save cards
			#return_value = expected_damage_to_receive < expected_damage_to_deal * 2 * temperament_modifier * deck_modifier
	#print('AI: should_draw return value: ', return_value)
	#return return_value
#
#
#func get_temperament_modifier(is_attacker):
	## Return a modifier based on the AI's Temperament and current role
	#match Temperament:
		#Temperament.BALANCED:
			#return 1.0
		#Temperament.AGGRESSIVE:
			#return 1.3 if is_attacker else 0.8
		#Temperament.DEFENSIVE:
			#return 0.7 if is_attacker else 1.4
		#Temperament.CHAOTIC:
			## Chaotic is unpredictable but with some logic
			#return randf_range(0.8, 1.5)
	#return 1.0
#
#
#func calculate_deck_modifier(card_probabilities, is_attacker, health_percentage):
	## Calculate a modifier based on the probability of drawing useful cards
	#
	#var modifier = 1.0
	#
	#if is_attacker:
		## When attacking, offensive cards are more valuable
		#if card_probabilities[CombatCard.Type.OFFENSIVE] > 0.5:
			#modifier *= 1.2  # More likely to draw if offensive cards are abundant
		#elif card_probabilities[CombatCard.Type.OFFENSIVE] < 0.2:
			#modifier *= 0.8  # Less likely to draw if offensive cards are rare
			#
		## Chaotic cards can be good for attacking too
		#if card_probabilities[CombatCard.Type.CHAOTIC] > 0.4:
			#modifier *= 1.1
	#else:
		## When defending, defensive cards are more valuable
		#if card_probabilities[CombatCard.Type.DEFENSIVE] > 0.5:
			#modifier *= 1.3  # More likely to draw if defensive cards are abundant
		#elif card_probabilities[CombatCard.Type.DEFENSIVE] < 0.2:
			#modifier *= 0.7  # Less likely to draw if defensive cards are rare
			#
		## At low health, strongly prefer drawing if defensive cards are available
		#if health_percentage < defense_threshold && card_probabilities[CombatCard.Type.DEFENSIVE] > 0.3:
			#modifier *= 1.5
	#
	## Special case for chaotic Temperament
	#if _temperament == Temperament.CHAOTIC && card_probabilities[CombatCard.Type.CHAOTIC] > 0.3:
		#modifier *= 1.2  # Chaotic AI loves chaotic cards!
	#
	#return modifier
