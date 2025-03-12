class_name D10DiceUI
extends Control

signal roll_completed(value)

# Configurable properties
@export var roll_time: float = 2.0
@export var roll_distance: Vector2 = Vector2(200, 0)
@export var roll_height: float = 30.0
@export var rotation_speed: float = 15.0
@export var bounce_count: int = 3
@export var face_textures: Array[Texture2D]

# Internal properties
var rolling: bool = false
var current_value: int = 1
var start_position: Vector2
var target_position: Vector2
var rng = RandomNumberGenerator.new()
var generated_polygon: Polygon2D

# Node references
#@onready var die_sprite: TextureRect = %DieSprite
@onready var value_label: Label = %ValueLabel
@onready var roll_sound: AudioStreamPlayer = %RollSound


func _ready():
	# Create a polygon node instead of using a TextureRect
	var polygon = Polygon2D.new()

	# Define the points for a 10-sided polygon (decagon)
	var points = []
	var radius = 30
	var center = Vector2(32, 32)

	for i in range(10):
		var angle = i * 2 * PI / 10
		var point = center + Vector2(cos(angle), sin(angle)) * radius
		points.append(point)

	# Set the polygon points
	polygon.polygon = points

	# Set the polygon color
	polygon.color = Color(0.8, 0.8, 0.8)

	# Add an outline
	var outline = Line2D.new()
	outline.points = points + [points[0]]  # Close the loop
	outline.width = 2
	outline.default_color = Color(0.3, 0.3, 0.3)

	# Replace the TextureRect with our polygon
	#remove_child(die_sprite)
	#add_child(polygon)
	#add_child(outline)
	generated_polygon = polygon
	add_child(generated_polygon)

	# Keep a reference to the polygon for rotation
	#die_sprite = polygon

	# Initialize with a default value
	set_die_face(current_value)
	start_position = position
	
func _process(delta):
	if rolling:
		# Randomly change the displayed face while rolling
		if rng.randf() < 0.2:  # 20% chance each frame to change face
			set_die_face(rng.randi_range(1, 10))

	# Rotate the die while rolling
	#die_sprite.rotation += rotation_speed * delta
	generated_polygon.rotation += rotation_speed * delta

func roll_die(target_pos = null):
	if rolling:
		return
		
	rolling = true
	rng.randomize()

	# Store original position
	start_position = position

	# Set target position if provided, otherwise use default distance
	if target_pos:
		target_position = target_pos
	else:
		target_position = position + roll_distance

	# Hide the value during roll
	value_label.visible = false

	# Play rolling sound
	if roll_sound:
		roll_sound.play()

	# Create the rolling animation tween
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	# Add arc motion and bounces
	var total_time = 0.0
	var segment_time = roll_time / (bounce_count + 1)
	var segment_distance = roll_distance / (bounce_count + 1)

	for i in range(bounce_count + 1):
		var bounce_height = roll_height * (1.0 - (i / float(bounce_count + 1)))
		var segment_start = start_position + segment_distance * i
		var segment_end = start_position + segment_distance * (i + 1)

		# Create intermediate points for arc motion
		var mid_point = (segment_start + segment_end) / 2
		mid_point.y -= bounce_height

		# First half of the arc
		tween.tween_property(self, "position", mid_point, segment_time / 2.0)
		# Second half of the arc
		tween.tween_property(self, "position", segment_end, segment_time / 2.0)

		total_time += segment_time

	# Stop rotation and set final value when done
	tween.tween_callback(func():
		# Choose final result (1-10)
		current_value = rng.randi_range(1, 10)
		set_die_face(current_value)
		generated_polygon.rotation = 0
		#die_sprite.rotation = 0
		value_label.visible = true
		rolling = false
		emit_signal("roll_completed", current_value)
	)

	return tween

func set_die_face(value: int):
	# Set the value (1-10)
	current_value = clampi(value, 1, 10)
	value_label.text = str(current_value)

	# Set the appropriate texture if available
	#if face_textures.size() >= current_value and face_textures[current_value - 1] != null:
		#die_sprite.texture = face_textures[current_value - 1]

func reset_position():
	position = start_position
