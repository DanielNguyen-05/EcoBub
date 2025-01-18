extends AudioStreamPlayer2D

var list = [preload("res://assets/bg music/Start Phase 1.ogg"),
			preload("res://assets/bg music/Start Phase 2.ogg"),
			preload("res://assets/bg music/Start Phase 3.ogg"),
			preload("res://assets/bg music/Start Phase 4.ogg"),
			preload("res://assets/bg music/Start Phase 5.ogg")]

var curr = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_song()
	pass # Replace with function body.


func play_song():
	self.stream = list[curr]
	self.play()
	print("Now Playing: ", list[curr].resource_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not self.is_playing():
		curr += 1
		if curr >= list.size():
			curr = 0
		play_song()
	pass
