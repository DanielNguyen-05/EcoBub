extends AudioStreamPlayer2D

@onready var bg_player = $"../BG Music"

var micro_list = [preload("res://assets/micro event/Micro Event 1.ogg"),
				  preload("res://assets/micro event/Micro Event 2.ogg"),
				  preload("res://assets/micro event/Micro Event 3.ogg")]

var macro_list = [preload("res://assets/macro event/Macro Event 1.ogg"),
				  preload("res://assets/macro event/Macro Event 2.ogg")]

var micro_curr = 0
var macro_curr = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func news_triggered(event_type: int):
	bg_player.stop()
	if event_type == 0:
		print("Micro Event")
		# Set Duration to play according to News Duration
	elif event_type == 1:
		print("Macro Event")
		# Set Duration to play according to News Duration
	elif event_type == 2:
		print("Natural Disaster")
		# Depends on the disaster (fire, rain, storm) play them accordingly
		# Set Duration to play according to News Duration
		
	
