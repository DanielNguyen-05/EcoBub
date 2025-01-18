extends Panel

func _ready() -> void:
	hide()
	pass

func update_portfolio(cash, owned_stocks):
	$VBoxContainer/Cash.text = str(cash) # Update cash label

	# Clear existing stock rows (except headers)
	for i in range($VBoxContainer.get_child_count() - 1, 2, -1):
		var child = $VBoxContainer.get_child(i)
		if child.get_class() == "HBoxContainer":
			$VBoxContainer.remove_child(child)
			child.queue_free()

	var total_portfolio_value = cash
	var stocks = "Owned Stocks: "
	
	for stock_name in owned_stocks:
		stocks += stock_name + ", "
		var shares = owned_stocks[stock_name].shares
		var price = owned_stocks[stock_name].price
		var value = shares * price
		total_portfolio_value += value

		# Add a new row for the stock
		var hbox = HBoxContainer.new()
		var name_label = Label.new()
		var shares_label = Label.new()
		var price_label = Label.new()
		var value_label = Label.new()

		name_label.text = stock_name
		shares_label.text = "Shares: " + str(shares)
		price_label.text = "Prices: " + str(price)
		value_label.text = "Total Value: " + str(value)

		hbox.add_child(name_label)
		hbox.add_child(shares_label)
		hbox.add_child(price_label)
		hbox.add_child(value_label)
		$VBoxContainer.add_child(hbox)
	
	if stocks.ends_with(", "):
		stocks = stocks.erase(stocks.length() - 2, 2)
	
	$VBoxContainer/OwnedStocks.text = stocks
	$VBoxContainer/NetWorth.text = "NetWorth: " + str(total_portfolio_value)


func _on_confirm_button_pressed():
	$"../Sounds/Click Button".play()
	hide()
	pass
