extends Panel

@onready var stock_option = $"../ButtonGroup/StockInfoDropdown"
@onready var clickable = $"../Sounds/Click Button"
@onready var non_clickable = $"../Sounds/Non Clickable Button"


signal buy_confirmed(quantity)

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

func _on_ok_button_pressed() -> void:
	var quantity_text = $LineEdit.text
	var selected_stock = stock_option.get_selected_id()
	if quantity_text.is_valid_int() && selected_stock != -1:
		var quantity = int(quantity_text)
		var price = MarketManager.stock_list[selected_stock]["current price"]
		
		if quantity > 0 && price * quantity <= MarketManager.cash:
			emit_signal("buy_confirmed", quantity)
			clickable.play()
			hide()
		else:
			non_clickable.play()
			# Show error message (e.g., in a label) that it needs to > 0
			pass
	else:
		non_clickable.play()
		# Show error message (e.g., in a label) for invalid input
		pass
	pass # Replace with function body.

func _on_cancel_button_pressed() -> void:
	clickable.play()
	hide()
	pass # Replace with function body.
