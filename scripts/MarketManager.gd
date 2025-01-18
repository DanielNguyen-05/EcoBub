extends Node

# You can use this to access the singleton instance, for example: MarketManager.cash
var cash = 1000.0

var stock_list = [
	{"name": "AAA", "initial_price": 10.0, "growth_rate": 0.2, "volatility": 0.5},
	{"name": "BBB", "initial_price": 25.0, "growth_rate": 0.1, "volatility": 0.2},
]

var news_list = []


@onready var buy_popup = get_node("BuyPopup")
@onready var stock_info_dropdown = get_node("ButtonGroup/StockInfoDropdown")


var selected_stock = null

func _ready():	
	# Spawn stock
	for stock_data in stock_list:
		spawn_stock_bubble(stock_data.name, stock_data.initial_price, stock_data.growth_rate, stock_data.volatility)
	print("MarketManager ready!") # Just to confirm it's loaded


# --- News Management ---
func load_news_from_csv(filepath) -> void:
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: ", filepath)
		return

	# Skip the header line (assuming your CSV has a header)
	file.get_csv_line()

	while not file.eof_reached():
		var line = file.get_csv_line()
		if line.size() >= 2:
			add_news(line[0], line[1], line[2], line[3]) # Add news to news_data array
		else:
			push_warning("Invalid line format in CSV: ", line)

func add_news(title, content, stock, impact) -> void:
	var news_item = {"title": title, "content": content, "stock": stock, "impact": impact}
	news_list.append(news_item)
	pass


# --- Stock Management ---
func spawn_stock_bubble(name, initial_price, growth_rate, volatility):
	pass # Implement later

# --- Player Actions ---
func buy_stock(stock, shares):
	pass # Implement later

func sell_stock(stock, shares):
	pass # Implement later

# --- Other Game Logic ---
func update_stock_prices(delta):
	pass # Implement later

func trigger_market_crash():
	pass # Implement later


func _on_buy_pressed() -> void:
	buy_popup.show()
	print("Buy pressed")
	pass # Replace with function body.


func _on_sell_pressed() -> void:
	print("Sell pressed")
	pass # Replace with function body.


func _on_stock_info_dropdown_item_selected(index: int) -> void:
	selected_stock = index
	pass # Replace with function body.


func _on_buy_popup_buy_confirmed(quantity: Variant) -> void:
	if selected_stock != null:
		buy_stock(selected_stock, quantity)
	pass # Replace with function body.
