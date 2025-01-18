extends Panel

@onready var ntitle = get_node("Title")
@onready var ncontent = get_node("Content")
@onready var click = $"../Click Button"

func _ready():
	hide() # Hide initially

func set_news_data(title, content):
	ntitle.text = title
	ncontent.text = content


func _on_close_pressed() -> void:
	click.play()
	hide()
	pass # Replace with function body.
