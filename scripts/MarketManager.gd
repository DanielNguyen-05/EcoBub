extends Node

# You can use this to access the singleton instance, for example: MarketManager.cash
var cash = 1000.0

func _ready():
	print("MarketManager ready!") # Just to confirm it's loaded

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
	print("Buy pressed")
	pass # Replace with function body.


func _on_sell_pressed() -> void:
	print("Sell pressed")
	pass # Replace with function body.
