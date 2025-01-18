extends Node2D

# You can use this to access the singleton instance, for example: MarketManager.cash
var cash = 1000.0

var stock_list = [
	{"name": "AAA", "current_price": 10.0, "growth_rate": 0.2, "volatility": 0.5},
	{"name": "BBB", "current_price": 25.0, "growth_rate": 0.1, "volatility": 0.2},
]

var owned_stocks = []

var news_list = []
var current_news_index = 0


@onready var buy_popup = get_node("../Main/World/PopupGroup/BuyPopup")
@onready var sell_popup = get_node("../Main/World/PopupGroup/SellPopup")
@onready var stock_info_dropdown = get_node("../Main/World/ButtonGroup/StockInfoDropdown")
@onready var news_ticker = get_node("../Main/World/NewsTickerLayer")
@onready var Menu = get_node("../Main/Menu")
@onready var portfolio = get_node("World/PopupGroup/PortfolioPanel")
@onready var portfolio_button = get_node("World/ButtonGroup/Portfolio")
@onready var World = get_node("../Main/World")

var selected_stock = null

func _ready():	
	# Spawn stock
	for stock_data in stock_list:
		spawn_stock_bubble(stock_data.name, stock_data.current_price, stock_data.growth_rate, stock_data.volatility)
	# Load news from CSV
	load_news_from_csv("res://assets/news.csv")
	news_ticker.update_news(news_list[current_news_index].title, news_list[current_news_index].content)
	print("MarketManager ready!") # Just to confirm it's loaded
	return
	
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
			add_news(line[0], line[1], int(line[2]), float(line[3])) # Add news to news_data array
		else:
			push_warning("Invalid line format in CSV: ", line)
	file.close()

func add_news(title, content, stock, impact) -> void:
	var news_item = {"title": title, "content": content, "stock": stock, "impact": impact}
	news_list.append(news_item)
	pass


# --- Stock Management ---
func spawn_stock_bubble(name, current_price, growth_rate, volatility):
	pass # Implement later

# --- Player Actions ---
func buy_stock(stockid: int, shares_quantity: int):
	cash -= shares_quantity * stock_list[stockid]["current price"]
	
	var stock_name = stock_list[stockid]["name"]
	
	for owned in owned_stocks:
		if owned.name == stock_name:
			owned.shares += shares_quantity
			portfolio_button.text = str(cash) + "$"
			return
	
	
	var new_stock = {"name": stock_name, "shares": shares_quantity}
	owned_stocks.append(new_stock)
	
	portfolio_button.text = str(cash) + "$"
	
	for owned in owned_stocks:
		print("Buy " + str(owned))
	
	return # Implement later

func sell_stock(stockid: int, shares_quantity: int):
	cash += shares_quantity * stock_list[stockid]["current price"]
	
	var stock_name = stock_list[stockid]["name"]
	
	for owned in owned_stocks:
		if owned["name"] == stock_name:
			owned["shares"] -= shares_quantity
			if owned["shares"] == 0:
				owned_stocks.erase(owned)
				pass
	
	portfolio_button.text = str(cash) + "$"
	return # Implement later

# --- Other Game Logic ---
func next_day() -> void:
	print("Old stock prices: ", stock_list)
	print("Old news: ", news_list[current_news_index].title)
	update_stock_prices(news_list[current_news_index].stock, news_list[current_news_index].impact) # Update stock prices
	print("New stock prices: ", stock_list)
	print("New news: ", news_list[current_news_index].title)
	current_news_index += 1
	if current_news_index >= news_list.size():
		current_news_index = 0
	news_ticker.update_news(news_list[current_news_index].title, news_list[current_news_index].content) # Update news ticker
	# Trigger a market crash if the conditions are met

	pass

func update_stock_prices(stockId, delta):
	stock_list[stockId].current_price += stock_list[stockId].growth_rate * delta
	stock_list[stockId].current_price += RandomNumberGenerator.new().randf_range(-stock_list[stockId].volatility, stock_list[stockId].volatility)
	pass # Implement later

func trigger_market_crash():
	pass # Implement later


func _on_buy_pressed() -> void:
	buy_popup.update_stock_name()
	buy_popup.show()
	print("Buy pressed")
	$"Sounds/Click Button".play()
	return # Replace with function body.


func _on_sell_pressed() -> void:
	sell_popup.update_stock_name()
	sell_popup.show()
	print("Sell pressed")
	$"Sounds/Click Button".play()
	return # Replace with function body.

func _on_next_pressed() -> void:
	print("Next pressed")
	$"Sounds/Click Button".play()
	return


func _on_stock_info_dropdown_item_selected(index: int) -> void:
	selected_stock = index
	return # Replace with function body.


func _on_buy_popup_buy_confirmed(quantity: Variant) -> void:
	if selected_stock != null:
		buy_stock(selected_stock, quantity)
	return # Replace with function body.

func _on_sell_popup_sell_confirmed(quantity: Variant) -> void:
	if selected_stock != null:
		sell_stock(selected_stock, quantity)
	return # Replace with function body.


func _on_portfolio_pressed() -> void:
	portfolio.update_portfolio(cash, owned_stocks)
	portfolio.show()
	return # Replace with function body.
