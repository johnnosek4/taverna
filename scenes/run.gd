class_name Run
extends Node


enum Mode {
	SINGLE,
	HOTSEAT,
	MULTI_SYNC,
	MULTI_ASYNC,
}

const COMBAT_SCENE = preload("res://combat_scene.tscn")
const DECK_BUILDER_SCENE = preload("res://ui/menus/deck/deck_builder_ui.tscn")

@onready var current_view: Node = %CurrentView
@onready var combat_menu: CombatMenu = %CombatMenu

var p1_stats: Stats
var p2_stats: Stats
var mode: Mode = Mode.HOTSEAT


func _ready() -> void:
	_generate_default_stats()
	combat_menu.single_player_button.pressed.connect(_on_combat_menu_single_player_button_pressed)
	combat_menu.p1_deck_view_button.pressed.connect(_on_combat_menu_p1_deck_view_button_pressed)
	combat_menu.p2_deck_view_button.pressed.connect(_on_combat_menu_p2_deck_view_button_pressed)
	combat_menu.pvp_button.pressed.connect(_on_combat_menu_pvp_button_pressed)

func _on_combat_menu_single_player_button_pressed() -> void:
	var sp_combat_scene = _change_view(COMBAT_SCENE) as CombatScene
	sp_combat_scene.p1_stats = p1_stats
	sp_combat_scene.p2_stats = p2_stats
	sp_combat_scene.initialize()


func _on_combat_menu_p1_deck_view_button_pressed() -> void:
	var deck_builder_scene = _change_view(DECK_BUILDER_SCENE) as DeckBuilderUI
	deck_builder_scene.stats = p1_stats
	deck_builder_scene.generate_card_views()
	

func _on_combat_menu_p2_deck_view_button_pressed() -> void:
	var deck_builder_scene = _change_view(DECK_BUILDER_SCENE) as DeckBuilderUI
	deck_builder_scene.stats = p2_stats
	deck_builder_scene.generate_card_views()
	

func _on_combat_menu_pvp_button_pressed() -> void:
	var sp_combat_scene = _change_view(COMBAT_SCENE) as CombatScene
	p2_stats.player_type = Stats.PlayerType.HUMAN
	sp_combat_scene.p1_stats = p1_stats
	sp_combat_scene.p2_stats = p2_stats
	sp_combat_scene.initialize()
	sp_combat_scene.start_combat()


func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)

	return new_view


func _generate_default_stats() -> void:
	var strike = Strike.new()
	var salve = Salve.new()
	var greater_salve = GreaterSalve.new()
	var posturing = Posturing.new()
	var vainglory = Vainglory.new()
	var gestalt = Gestalt.new()
	var turtle = Turtle.new()
	var block = Block.new()
	var riposte = Riposte.new()
	var deadly = Deadly.new()
	var noxious = Noxious.new()
	var finisher = Finisher.new()
	var swarm = Swarm.new()
	var trojka = Trojka.new()
	var balance = Balance.new()
	var bloodlust = Bloodlust.new()
	var fortify = Fortify.new()
	var chokepoint = ChokePoint.new()
	var forged = Forged.new()
	var flank = Flank.new()
	var gambit = Gambit.new()
	var pyrrhic = Pyrrhic.new()
	var harbinger = Harbinger.new()
	var martyr = Martyr.new()
	
	#var feint = Feint.new() #NOTE: commented out for now while i decide what to do with status effects
	
	#var bite_and_claw = BiteAndClaw.new()
	#var boiling_tar_boots = BoilingTarBoots.new()
	#var chains_of_malice = ChainsOfMalice.new()
	#var crystal_skin = CrystalSkin.new()
	#var death_ray = DeathRay.new()
	#var dragon_scale_kite = DragonScaleKite.new()
	#var feaster = Feaster.new() # I made this one as test
	#var glacier_stone = GlacierStone.new()
	#var harden_scales = HardenScales.new()
	#var heartstring_bow = HeartStringBow.new()
	#var killer_instinct = KillerInstinct.new()
	#var pocked_smithy = PockedSmithy.new()
	#var spider_fang_mail = SpiderFangMail.new()
	#var stone_fists = StoneFists.new()
	#var turn_to_smoke = TurnToSmoke.new()
	#var wand_of_affliction = WandOfAffliction.new()
	#var worm_fetish = WormFetish.new()

	var template_deck = {
		block: 5,
		riposte: 5,
		deadly: 3,
		salve: 1,
		greater_salve: 1,
		posturing: 1,
		vainglory: 1,
		gestalt: 1,
		turtle: 1, 
		noxious: 1,
		finisher: 1,
		swarm: 5,
		trojka: 2,
		balance: 1,
		bloodlust: 1,
		fortify: 3,
		chokepoint: 1,
		forged: 1,
		flank: 1,
		gambit: 1,
		pyrrhic: 1,
		harbinger: 1,
		martyr: 1,
		#feint: 2,
		}
		
	var test_deck1 = {
		pyrrhic: 5,
		harbinger: 3,
		martyr: 3,
	}
	
	var balance_deck = {
		strike: 5,
		deadly: 1,
		gestalt: 1,
		block: 5,
		greater_salve: 2,
		balance: 3,
		trojka: 3,
		posturing: 1
	}
	
	
	var inexorable_deck = {
		forged: 5,
		bloodlust: 3,
		trojka: 2,
		deadly: 2
	}


	var fury_deck = {
		deadly: 2,
		gestalt: 1,
		finisher: 1,
		swarm: 5,
		trojka: 2,
		bloodlust: 2,
		}
		
	#this would work better
	var defensive_deck = {
		block: 5,
		riposte: 5,
		deadly: 3,
		#feint: 2,
		vainglory: 3,
		gestalt: 3,
		turtle: 1, 
		fortify: 3,
		chokepoint: 1,
		}


	var clown_deck = {
		greater_salve: 5,
		noxious: 5,
		trojka: 3,
		balance: 3,
		}

	
	p1_stats = Stats.new()
	p1_stats.card_pile = test_deck1
		
	p2_stats = Stats.new()
	p2_stats.name = "Opponent"
	p2_stats.player_type = Stats.PlayerType.AI
	p2_stats.card_pile = inexorable_deck
