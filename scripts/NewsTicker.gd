extends CanvasLayer

var news_item = {"title": "title", "content": "content"}
@onready var news_popup = get_node("../NewsPopup")

func _ready():
	update_news("Market in Turmoil", "Experts warn of a potential bubble...")

func update_news(title, content):
	news_item = {"title": title, "content": content}
	update_ticker()

func update_ticker():
	var label = $NewsTickerLabel # Assuming you named the RichTextLabel "NewsTickerLabel"
	label.text = news_item.title + ": " + news_item.content

func _on_read_more_pressed() -> void:
	news_popup.set_news_data(news_item.title, news_item.content)
	news_popup.show()
	pass # Replace with function body.
