extends Panel

@onready var restart = %Restart
@onready var quit = %Quit

func _ready() -> void:
	restart.pressed.connect(_on_restart_pressed)
	quit.pressed.connect(_on_quit_pressed)
	

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().quit()
