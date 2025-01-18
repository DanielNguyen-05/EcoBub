extends Panel

signal buy_confirmed(quantity)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.

func _on_ok_button_pressed() -> void:
	var quantity_text = $LineEdit.text
	if quantity_text.is_valid_int():
		var quantity = int(quantity_text)
		if quantity > 0:
			emit_signal("buy_confirmed", quantity)
			hide()
		else:
			# Show error message (e.g., in a label) that it needs to > 0
			pass
	else:
		# Show error message (e.g., in a label) for invalid input
		pass
	pass # Replace with function body.


func _on_cancel_button_pressed() -> void:
	hide()
	pass # Replace with function body.
