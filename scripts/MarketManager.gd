extends Node2D

# You can use this to access the singleton instance, for example: MarketManager.cash
var cash = 1000.0
var networth = 0
var count = 0

var stock_list = [
	{"name": "TECH", "current_price": 75.0, "growth_rate": 0.2, "volatility": 0.5, "later_price": 75.0},
	{"name": "RENEW ENERGY", "current_price": 51.0, "growth_rate": 0.1, "volatility": 0.2, "later_price": 51.0},
	{"name": "CRYPTO", "current_price": 60.0, "growth_rate": 0.3, "volatility": 0.5, "later_price": 60.0},
	{"name": "REAL ESTATE", "current_price": 92.0, "growth_rate": 0.9, "volatility": 0.5, "later_price": 92.0},
]

var owned_stocks = []

var news_list0 = []
var news_list1 = []
var news_list2 = []
var news_list3 = []

var current_day = 0

signal networth_update(net)
signal panic_update(net)

var game_duration = 180.0
var game_over = false
var panic_meter = 0.0


@onready var buy_button = get_node("../Main/World/ButtonGroup/Buy")
@onready var sell_button = get_node("../Main/World/ButtonGroup/Sell")
@onready var stock_info_dropdown = get_node("../Main/World/ButtonGroup/StockInfoDropdown")
@onready var news_ticker = get_node("../Main/World/NewsTickerLayer")
@onready var Menu = get_node("../Main/Menu")
@onready var portfolio = get_node("../Main/World/PopupGroup/PortfolioPanel")
@onready var portfolio_button = get_node("../Main/World/ButtonGroup/Portfolio")
@onready var World = get_node("../Main/World")

var selected_stock = null

var selected_story = 0

func getnews(listid, day):
	day = day % 19
	if listid == 0:
		return news_list0[day]
	elif listid == 1:
		return news_list1[day]
	elif listid == 2:
		return news_list2[day]
	elif listid == 3:
		return news_list3[day]

func _ready() -> void:	
	# Load news from CSV
	load_news_from_csv("res://assets/news1.csv", 0)
	load_news_from_csv("res://assets/news2.csv", 1)
	load_news_from_csv("res://assets/news3.csv", 2)
	load_news_from_csv("res://assets/news4.csv", 3)
	news_ticker.update_news(getnews(selected_story, current_day).title, getnews(selected_story, current_day).content)
	print("MarketManager ready!") # Just to confirm it's loaded
	return
	
# --- News Management ---
func load_news_from_csv(filepath, id) -> void:
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: ", filepath)
		return

	# Skip the header line (assuming your CSV has a header)
	file.get_csv_line()

	while not file.eof_reached():
		var line = file.get_csv_line()
		if line.size() >= 2:
			add_news(id, line[0], line[1], int(line[2]), float(line[3])) # Add news to news_data array
		else:
			push_warning("Invalid line format in CSV: ", line)
	file.close()

func add_news(id, title, content, stock, impact) -> void:
	var news_item = {"title": title, "content": content, "stock": stock, "impact": impact}
	if id == 0:
		news_list0.append(news_item)
	elif id == 1:
		news_list1.append(news_item)
	elif id == 2:
		news_list2.append(news_item)
	elif id == 3:
		news_list3.append(news_item)
	else:
		push_error("Invalid news ID: ", id)
	pass


# --- Player Actions ---
func buy_stock(stockid: int, shares_quantity: int) -> void:
	print("Inside buy_stock")
	cash -= shares_quantity * stock_list[stockid]["current_price"]
	
	var stock_name = stock_list[stockid]["name"]
	
	
	for owned in owned_stocks:
		if owned.name == stock_name:
			owned.shares += shares_quantity
			portfolio_button.text = str((cash * 100)/100) + "$"
			$"World/ButtonGroup/Stock Number".text = str(owned.shares)
			sell_button.update_owned(owned_stocks)
			return
	
	
	var new_stock = {"name": stock_name, "shares": shares_quantity}
	owned_stocks.append(new_stock)
	
	portfolio_button.text = str((cash * 100)/100) + "$"
	$"World/ButtonGroup/Stock Number".text = str(shares_quantity)
	
	sell_button.update_owned(owned_stocks)
	
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
			$"World/ButtonGroup/Stock Number".text = str(owned.shares)
			if owned["shares"] == 0:
				owned_stocks.erase(owned)
				pass
	
	portfolio_button.text = str((cash * 100)/100) + "$"
	return # Implement later

# --- Other Game Logic ---
func next_day() -> void:
	#draw graph(current price, later price)
	selected_story = RandomNumberGenerator.new().randi_range(0, 3)
	if current_day - 1 >= 0:
		affect_later_stock_price(getnews(selected_story, current_day - 1).stock - 1, getnews(selected_story, current_day - 1).impact)
	current_day += 1
	news_ticker.update_news(getnews(selected_story, current_day).title, getnews(selected_story, current_day).content)
	update_stock_prices()

	pass
	
func get_owned_stocks():
	return owned_stocks

func affect_later_stock_price(stockID, impact):
	# TODO: Implement this function to affect the stock price more realistically
	stock_list[stockID-1]["later_price"] += impact * stock_list[stockID-1]["growth_rate"]
	stock_list[stockID-1]["volatility"] = round(stock_list[stockID-1]["volatility"] * 100) / 100
	if impact > 2:
		stock_list[stockID]["volatility"] += 0.2
	pass

func update_stock_prices():
	for stock in stock_list:
		stock.current_price += stock.growth_rate * RandomNumberGenerator.new().randf_range(-stock.volatility, stock.volatility)
		stock.current_price += RandomNumberGenerator.new().randf_range(-stock.volatility, stock.volatility)
		panic_meter += stock.volatility
		stock.later_price = stock.current_price + stock.growth_rate * RandomNumberGenerator.new().randf_range(-stock.volatility, stock.volatility)
		stock.current_price = round(stock.current_price * 100) / 100
		stock.later_price = round(stock.later_price * 100) / 100
	
	var id = $World/ButtonGroup/StockInfoDropdown.get_selected_id()
	
	match id:
		0:
			$"World/ButtonGroup/Stock Price".text = str((stock_list[0].current_price * 100)/100)
		1:
			$"World/ButtonGroup/Stock Price".text = str((stock_list[1].current_price * 100)/100)
		2:
			$"World/ButtonGroup/Stock Price".text = str((stock_list[2].current_price * 100)/100)
		3:
			$"World/ButtonGroup/Stock Price".text = str((stock_list[3].current_price * 100)/100)
		
	if panic_meter > 50:
		trigger_market_crash()
	
	pass
	
var panic_state = 0

func _process(delta: float) -> void:
	game_duration -= delta
	if game_duration <= 0:
		game_over = true
	if game_over:
		trigger_market_crash()
	if panic_meter > 23 && panic_state == 0:
		emit_signal("panic_update", 1)
		panic_state += 1
	if panic_meter > 46 && panic_state == 1:
		emit_signal("panic_update", 2)
		panic_state += 1
	
func trigger_market_crash():
	# TODO: Play crash effect
	var price
	for stock_name in owned_stocks:
		var shares = stock_name.shares
		
		for market_stocks in stock_list:
			if market_stocks["name"] == stock_name.name:
				price = market_stocks["current_price"]
				break
		
		var value = shares * price
		networth += value
	networth += cash
	emit_signal("networth_update", networth)
	pass # Implement later


func _on_buy_pressed() -> void:
	buy_button.update_cash(cash)
	buy_button.buy_valid_check()
	print("Buy pressed")
	return # Replace with function body.


func _on_sell_pressed() -> void:
	print("Sell pressed")
	sell_button.sell_valid_check()
	return # Replace with function body.

func _on_next_pressed() -> void:
	print("Next pressed")
	$World/Sounds/Clickable.play()
	next_day()
	return

func _on_stock_info_dropdown_item_selected(index: int) -> void:
	selected_stock = index
	var numb = "0"
	var price = str((stock_list[selected_stock]["current_price"] * 100)/100)
	
	if selected_stock == -1:
		numb = "-"
		price = "-"
	else:
		for owned in owned_stocks:
			if owned.name == stock_list[selected_stock].name:
				numb = str(owned.shares)
				break
	$"World/ButtonGroup/Stock Number".text = numb
	$"World/ButtonGroup/Stock Price".text = price
	
		
	return # Replace with function body.


func _on_buy_buy_confirmed(quantity: Variant) -> void:
	if selected_stock != null:
		buy_stock(selected_stock, quantity)
	return # Replace with function body.

func _on_sell_sell_confirmed(quantity: Variant) -> void:
	if selected_stock != null:
		sell_stock(selected_stock, quantity)
	return # Replace with function body.


func _on_portfolio_pressed() -> void:
	portfolio.update_portfolio(cash, owned_stocks, stock_list)
	portfolio.show()
	return # Replace with function body.

func _on_menu_tree_exited() -> void:
	news_ticker.show()
	World.show()
	pass # Replace with function body.


func _on_increase_pressed() -> void:
	count += 1
	$World/ButtonGroup/Number.text = str(count)
	pass # Replace with function body.


func _on_decrease_pressed() -> void:
	count -= 1
	if count < 0:
		count = 0
	$World/ButtonGroup/Number.text = str(count)
	pass # Replace with function body.
