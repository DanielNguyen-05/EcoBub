extends Node2D

# You can use this to access the singleton instance, for example: MarketManager.cash
var cash = 1000.0

var stock_list = [
	{"name": "AAA", "initial_price": 10.0, "growth_rate": 0.2, "volatility": 0.5},
	{"name": "BBB", "initial_price": 25.0, "growth_rate": 0.1, "volatility": 0.2},
]

@onready var buy_popup = get_node("BuyPopup")
@onready var sell_popup = get_node("SellPopup")
@onready var stock_info_dropdown = get_node("ButtonGroup/StockInfoDropdown")

var selected_stock = null

func _ready():	
	# Spawn stock
	for stock_data in stock_list:
		spawn_stock_bubble(stock_data.name, stock_data.initial_price, stock_data.growth_rate, stock_data.volatility)
	print("MarketManager ready!") # Just to confirm it's loaded
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
	buy_popup.update_stock_name()
	buy_popup.show()
	print("Buy pressed")
	$"Sounds/Click Button".play()
	pass # Replace with function body.


func _on_sell_pressed() -> void:
	sell_popup.update_stock_name()
	sell_popup.show()
	print("Sell pressed")
	$"Sounds/Click Button".play()
	pass # Replace with function body.

func _on_next_pressed() -> void:
	print("Next pressed")
	$"Sounds/Click Button".play()
	pass


func _on_stock_info_dropdown_item_selected(index: int) -> void:
	selected_stock = index
	pass # Replace with function body.


func _on_buy_popup_buy_confirmed(quantity: Variant) -> void:
	print(selected_stock, quantity)
	if selected_stock != null:
		buy_stock(selected_stock, quantity)
	pass # Replace with function body.
