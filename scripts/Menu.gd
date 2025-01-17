extends Control

func _ready():
	# Connect button signals using Callable
	$StartGame.connect("pressed", Callable(self, "_on_start_button_pressed"))
	$QuitGame.connect("pressed", Callable(self, "_on_quit_button_pressed"))

func _on_start_button_pressed():
	print("Start button pressed")
	get_tree().change_scene_to_file("res://scenes/Scene1.tscn")  # Đảm bảo rằng đường dẫn đúng

func _on_quit_button_pressed():
	print("Quit button pressed")
	get_tree().quit() 
