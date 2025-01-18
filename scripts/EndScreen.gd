extends Node2D

# Khai báo biến để lưu trữ ColorRect và các nút
var background: ColorRect
@onready var final: Label = get_node("Label")
@onready var quit_button: TextureButton = get_node("QuitButton")
@onready var try_again_button: TextureButton = get_node("TryAgainButton")
var networth = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	# Tìm kiếm ColorRect là node con
	background = $ColorRect
	
	# Đặt màu nền cho ColorRect (ví dụ màu #181425)
	background.color = Color(0.094, 0.078, 0.145)  # Màu #181425 (RGB: 24, 20, 37)
	
	
func _on_try_again_button_pressed() -> void:
	print("Try Again button pressed")  # In ra thông báo khi nút Try Again được nhấn
	
	get_tree().change_scene_to_file("res://scenes/Main.tscn")  # Tải lại cảnh ban đầu


func _on_quit_button_pressed() -> void:
	print("Quit button pressed")  # In ra thông báo khi nút Quit được nhấn
	get_tree().quit()  # Đóng game


func _on_main_networth_update(net: Variant) -> void:
	final.text = str(ceil(net * 100)/100)
	show()
	pass # Replace with function body.
