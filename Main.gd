extends Control

func _ready():
	# Connect button signals using Callable
	$IncreaseButton.connect("pressed", Callable(self, "_on_increase_button_pressed"))
	$DecreaseButton.connect("pressed", Callable(self, "_on_decrease_button_pressed"))

func _on_increase_button_pressed():
	print("Increase button pressed")
	# Dùng change_scene_to() thay vì change_scene()
	get_tree().change_scene_to_file("res://NextScreen.tscn") # Đảm bảo rằng đường dẫn đúng

func _on_decrease_button_pressed():
	print("Decrease button pressed")
	# Dùng change_scene_to() thay vì change_scene()
	get_tree().change_scene_to_file("res://NextScreen.tscn") # Đảm bảo rằng đường dẫn đúng
