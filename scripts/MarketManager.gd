extends Node

# You can use this to access the singleton instance, for example: MarketManager.cash
var cash = 1000.0

@onready var buy_popup = get_node("BuyPopup")
var selected_stock

func _ready():
	#buy_popup.hide()
	#buy_popup.connect("buy_confirmed", _on_buy_confirmed)
	print("MarketManager ready!") # Just to confirm it's loaded

func _on_buy_confirmed(quantity):
	if selected_stock != null:
		buy_stock(selected_stock, quantity)

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
