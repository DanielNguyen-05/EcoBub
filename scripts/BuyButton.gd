extends TextureButton

@onready var stock_option = $"../StockInfoDropdown"

signal buy_confirmed(quantity)

var remaining_cash

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_cash(cash: int):
	remaining_cash = cash

func buy_valid_check() -> void:
	var quantity_text = $"../Number".text
	var selected_stock = stock_option.get_selected_id()
	if quantity_text.is_valid_int() && selected_stock != -1:
		var quantity = int(quantity_text)
		var price = MarketManager.stock_list[selected_stock]["current_price"]
		
		if quantity > 0 && price * quantity <= remaining_cash:
			emit_signal("buy_confirmed", quantity)
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
