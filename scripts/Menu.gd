extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		# Kiểm tra nếu phím Enter được nhấn
		get_tree().change_scene_to_file("res://scenes/main.tscn")
