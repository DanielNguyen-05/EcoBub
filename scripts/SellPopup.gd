extends Panel

@onready var stock_option = $"../../ButtonGroup/StockInfoDropdown"

signal sell_confirmed(quantity)

var owned = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.
	
func update_stock_name() -> void:
	var selected_stock = stock_option.get_selected_id()
	if selected_stock != -1:
		$"Stock Name".text = "Stock: " + stock_option.get_item_text(selected_stock)
	else:
		$"Stock Name".text = "Stock: Unselected"
	pass

func update_owned(owned_stocks: Array):
	owned.clear()
	owned = owned_stocks

func _on_ok_button_pressed() -> void:
	var quantity_text = $LineEdit.text
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
			hide()
		else:
			$"../../Sounds/Non-Clickable".play()
			# Show error message (e.g., in a label) that it needs to > 0
			pass
	else:
		$"../../Sounds/Non-Clickable".play()
		# Show error message (e.g., in a label) for invalid input
		pass
	pass # Replace with function body.


func _on_cancel_button_pressed() -> void:
	$"../../Sounds/Clickable".play()
	hide()
	pass # Replace with function body.
