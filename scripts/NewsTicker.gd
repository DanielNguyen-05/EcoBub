extends CanvasLayer

var news = {"title": "title", "content": "content"}
@onready var news_popup = get_node("../PopupGroup/NewsPopup")
@onready var news_open = $"../Sounds/News Open"

func _ready():
	hide()

func update_news(title, content):
	news = {"title": title, "content": content}
	update_ticker()

func update_ticker():
	var label = $NewsTickerLabel # Assuming you named the RichTextLabel "NewsTickerLabel"
	label.text = news.title

func _on_read_more_pressed() -> void:
	news_open.play(0.5)
	news_popup.set_news_data(news.title, news.content)
	news_popup.show()
	pass # Replace with function body.
