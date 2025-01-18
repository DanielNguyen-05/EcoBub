extends Panel

@onready var ntitle = get_node("Title")
@onready var ncontent = get_node("Content")
@onready var news_close = $"../../Sounds/News Close"

func _ready():
	hide() # Hide initially

func set_news_data(title, content):
	ntitle.text = title
	ncontent.text = content

func _on_close_pressed() -> void:
	news_close.play(0.5)
	hide()
	pass # Replace with function body.
