extends Node2D

# You can use this to access the singleton instance, for example: MarketManager.cash
var cash = 1000.0

var stock_list = [
	{"name": "AAA", "current_price": 10.0, "growth_rate": 0.2, "volatility": 0.8, "later_price": 10.0},
	{"name": "BBB", "current_price": 25.0, "growth_rate": 0.1, "volatility": 0.9, "later_price": 25.0},
]

var owned_stocks = []

var news_list = []
var current_day = 0

var game_duration = 300.0
var game_over = false
var panic_meter = 0.0

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
	# Load news from CSV
	load_news_from_csv("res://assets/news.csv")
	# news_ticker.update_news(news_list[current_news_index].title, news_list[current_news_index].content)
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


# --- Player Actions ---
func buy_stock(stockid: int, shares_quantity: int):
	cash -= shares_quantity * stock_list[stockid]["current_price"]
	
	var stock_name = stock_list[stockid]["name"]
	
	for owned in owned_stocks:
		if owned.name == stock_name:
			owned.shares += shares_quantity
			portfolio_button.text = str(cash) + "$"
			return
	
	
	var new_stock = {"name": stock_name, "shares": shares_quantity}
	owned_stocks.append(new_stock)
	
	portfolio_button.text = str(cash) + "$"
	
	sell_popup.update_owned(owned_stocks)
	
	stock_list[stockid]["growth_rate"] += 0.08
	stock_list[stockid]["later_price"] += 0.12 * shares_quantity

	return # Implement later

func sell_stock(stockid: int, shares_quantity: int):
	cash += shares_quantity * stock_list[stockid]["current_price"]
	
	var stock_name = stock_list[stockid]["name"]
	
	stock_list[stockid]["growth_rate"] -= 0.05
	stock_list[stockid]["later_price"] -= 0.2 * shares_quantity

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
	#draw graph(current price, later price)
	if current_day - 1 >= 0:
		affect_later_stock_price(news_list[(current_day - 1) % news_list.size()].stock, news_list[(current_day - 1) % news_list.size()].impact)
	current_day += 1
	update_stock_prices()

	pass
	
func get_owned_stocks():
	print(owned_stocks)
	return owned_stocks

func affect_later_stock_price(stockID, impact):
	# TODO: Implement this function to affect the stock price more realistically
	stock_list[stockID]["later_price"] += impact * stock_list[stockID]["growth_rate"]
	if impact > 2:
		stock_list[stockID]["volatility"] += 0.2

	pass

func update_stock_prices():
	for stock in stock_list:
		stock.current_price += stock.growth_rate * RandomNumberGenerator.new().randf_range(-stock.volatility, stock.volatility)
		stock.current_price += RandomNumberGenerator.new().randf_range(-stock.volatility, stock.volatility)
		panic_meter += stock.volatility
		stock.later_price = stock.current_price + stock.growth_rate * RandomNumberGenerator.new().randf_range(-stock.volatility, stock.volatility)
	if panic_meter > 10:
		trigger_market_crash()
	pass

func _process(delta: float) -> void:
	game_duration -= delta
	if game_duration <= 0:
		game_over = true
	if game_over:
		trigger_market_crash()

func trigger_market_crash():
	# TODO: Play crash effect
	get_tree().change_scene_to_file("res://scenes/EndScreen.tscn")
	pass # Implement later


func _on_buy_pressed() -> void:
	buy_popup.update_stock_name()
	buy_popup.show()
	print("Buy pressed")
	$World/Sounds/Clickable.play()
	return # Replace with function body.


func _on_sell_pressed() -> void:
	sell_popup.update_stock_name()
	sell_popup.show()
	print("Sell pressed")
	$World/Sounds/Clickable.play()
	return # Replace with function body.

func _on_next_pressed() -> void:
	print("Next pressed")
	$World/Sounds/Clickable.play()
	next_day()
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

func _on_menu_tree_exited() -> void:
	news_ticker.show()
	World.show()
	pass # Replace with function body.
