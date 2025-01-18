extends Panel


func _ready() -> void:
	hide()
	pass

func update_portfolio(cash: int, owned_stocks: Array, stock_list: Array):
	$Cash.text = str((cash * 100)/100) + "$" # Update cash label

	var networth = (cash * 100)/100
	var total_val = 0
	
	var price = 0
	
	for stock_name in owned_stocks:
		var shares = stock_name.shares
		
		for market_stocks in stock_list:
			if market_stocks["name"] == stock_name.name:
				price = market_stocks["current_price"]
				break
		
		var value = shares * price
		networth += value
		total_val += value
		
		match stock_name.name:
			"TECH":
				$TECH/Shares.text = str(shares)
			"RENEW ENERGY":
				$"RENEW ENERGY/Shares".text = str(shares)
			"CRYPTO":
				$CRYPTO/Shares.text = str(shares)
			"REAL ESTATE":
				$"REAL ESTATE/Shares".text = str(shares)
		
	for stock_name in stock_list:
		match stock_name.name:
			"TECH":
				$TECH/Price.text = str((stock_list[0].current_price * 100)/100)
			"RENEW ENERGY":
				$"RENEW ENERGY/Price".text = str((stock_list[1].current_price * 100)/100)
			"CRYPTO":
				$CRYPTO/Price.text = str((stock_list[2].current_price * 100)/100)
			"REAL ESTATE":
				$"REAL ESTATE/Price".text = str((stock_list[3].current_price * 100)/100)
	
	$"Stocks Group/Total Value".text = str((total_val * 100)/100)
	$NetWorth.text = str((networth * 100)/100) + "$"


func _on_confirm_button_pressed():
	$"../../Sounds/Clickable".play()
	hide()
	pass
