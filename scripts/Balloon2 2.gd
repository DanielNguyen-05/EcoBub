extends CharacterBody2D

# Define the animation states
enum State { NORMAL, DANGER, BREAK }
var current_state: State = State.NORMAL
var animated_node: AnimatedSprite2D

const FLOAT_HEIGHT = 28      # Float height
const FLOAT_TIME = 2.0       # Time to complete one float cycle (up and down)
const SPEED = 100.0          # Horizontal movement speed (if needed)

var tween: Tween             # Tween for floating
var is_floating = true       # Floating state

# Define the textures for the states
var normal_textures: Array
var danger_textures: Array
var break_textures: Array

func _ready():
	# Assume the AnimatedSprite2D node is a child named "Animated"
	animated_node = $Animated
	set_state(State.NORMAL)  # Set the initial state to Normal
	
	# Pre-load textures for each state
	normal_textures = [load("res://normal_1.png"), load("res://normal_2.png")]
	danger_textures = [load("res://danger_1.png"), load("res://danger_2.png")]
	break_textures = [load("res://break_1.png"), load("res://break_2.png")]
	
	# Start floating effect
	if is_floating:
		start_floating()

func _physics_process(delta: float) -> void:
	# Handle horizontal movement (optional)
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		position.x += direction * SPEED * delta

func start_floating():
	# Kill existing tween if it exists
	if tween:
		tween.kill()
		
	# Create new tween
	tween = create_tween()
	
	# Store current Y position
	var start_y = position.y

	# Create tween for upward movement
	tween.tween_property(self, "position:y", 
		0 - FLOAT_HEIGHT, 
		FLOAT_TIME / 2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# Create tween for downward movement
	tween.tween_property(self, "position:y", 
		0 + FLOAT_HEIGHT, 
		FLOAT_TIME / 2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# Repeat the floating motion
	tween.finished.connect(start_floating)

func set_state(state: State) -> void:
	# If the state is the same as the current one, skip to avoid restarting the animation
	if state == current_state:
		return

	# Set the new state
	current_state = state

	# Change textures based on state
	match state:
		State.NORMAL:
			change_textures(normal_textures)
		State.DANGER:
			change_textures(danger_textures)
		State.BREAK:
			change_textures(break_textures)

func change_textures(textures: Array) -> void:
	# Change the texture of the animated node smoothly using tween
	# You can change frame or texture here
	for i in range(textures.size()):
		tween.tween_property(animated_node, "frame", i, 0.5)
		animated_node.texture = textures[i]
