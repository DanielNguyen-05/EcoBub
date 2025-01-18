extends TextureButton

@onready var stock_option = $"../StockInfoDropdown"

signal sell_confirmed(quantity)

var owned = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_owned(owned_stocks: Array):
	owned = owned_stocks

func sell_valid_check() -> void:
	var quantity_text = $"../Number".text
	var selected_stock = stock_option.get_selected_id()
	if quantity_text.is_valid_int() && selected_stock != -1:
		var quantity = int(quantity_text)
		var owned_quantity = -1
		
		
		for stocks in owned:
			if stocks.name == MarketManager.stock_list[selected_stock].name:
				owned_quantity = stocks.shares
				break

		if quantity > 0 && quantity <= owned_quantity:
			emit_signal("sell_confirmed", quantity)
			$"../../Sounds/Clickable".play()
		else:
			$"../../Sounds/Non-Clickable".play()
			# Show error message (e.g., in a label) that it needs to > 0
			pass
	else:
		$"../../Sounds/Non-Clickable".play()
		# Show error message (e.g., in a label) for invalid input
		pass
	pass # Replace with function body.
