extends Panel


func _ready() -> void:
	hide()
	pass

func update_portfolio(cash: int, owned_stocks: Array, stock_list: Array):
	$VBoxContainer/Cash.text = "Cash: " + str(ceil(cash * 100)/100) # Update cash label

	# Clear existing stock rows (except headers)
	for i in range($VBoxContainer.get_child_count() - 1, 2, -1):
		var child = $VBoxContainer.get_child(i)
		if child.get_class() == "HBoxContainer":
			$VBoxContainer.remove_child(child)
			child.queue_free()

	var total_portfolio_value = ceil(cash * 100)/100
	var current_stocks = "Owned Stocks: "
	
	
	for stock_name in owned_stocks:
		current_stocks += stock_name["name"] + ", "
		var shares = stock_name["shares"]
		var price
		
		for market_stocks in stock_list:
			if market_stocks["name"] == stock_name.name:
				price = market_stocks["current_price"]
				break
		
		var value = shares * price
		total_portfolio_value += value

		# Add a new row for the stock
		var hbox = HBoxContainer.new()
		var name_label = Label.new()
		var shares_label = Label.new()
		var price_label = Label.new()
		var value_label = Label.new()

		name_label.text = stock_name.name
		shares_label.text = "Shares: " + str(shares)
		price_label.text = "Prices: " + str(ceil(price * 100)/100)
		value_label.text = "Total Value: " + str(ceil(value * 100)/100)

		hbox.add_child(name_label)
		hbox.add_child(shares_label)
		hbox.add_child(price_label)
		hbox.add_child(value_label)
		$VBoxContainer.add_child(hbox)
	
	if current_stocks.ends_with(", "):
		current_stocks = current_stocks.erase(current_stocks.length() - 2, 2)
	
	$VBoxContainer/OwnedStocks.text = current_stocks
	$VBoxContainer/NetWorth.text = "NetWorth: " + str(ceil(total_portfolio_value * 100)/100)


func _on_confirm_button_pressed():
	$"../../Sounds/Clickable".play()
	hide()
	pass
