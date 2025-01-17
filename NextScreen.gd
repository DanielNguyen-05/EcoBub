extends Node2D

# Dữ liệu giả định cho biểu đồ chứng khoán (open, close, high, low)
var data_points = [
	{"open": 150, "close": 200, "high": 220, "low": 130},
	{"open": 200, "close": 180, "high": 210, "low": 170},
	{"open": 180, "close": 160, "high": 190, "low": 150},
	{"open": 160, "close": 175, "high": 180, "low": 140},
	{"open": 175, "close": 165, "high": 185, "low": 160}
]

var bar_width = 30

func _draw():
	# Vẽ các thanh nến (candlesticks)
	for i in range(data_points.size()):
		var data = data_points[i]
		var open_price = data["open"]
		var close_price = data["close"]
		var high_price = data["high"]
		var low_price = data["low"]

		# Tính toán vị trí của thanh nến
		var x_pos = i * (bar_width + 10) + 10  # Vị trí x của nến
		var y_pos_body_top = min(open_price, close_price)  # Vị trí y của phần thân (body) của nến
		var body_height = abs(open_price - close_price)  # Chiều cao phần thân nến

		# Vẽ bóng trên (wick) - đường từ high đến body
		draw_line(Vector2(x_pos + bar_width / 2, 250 - high_price), Vector2(x_pos + bar_width / 2, 250 - y_pos_body_top), Color(0, 0, 0), 2)
		
		# Vẽ bóng dưới (wick) - đường từ low đến body
		draw_line(Vector2(x_pos + bar_width / 2, 250 - low_price), Vector2(x_pos + bar_width / 2, 250 - y_pos_body_top - body_height), Color(0, 0, 0), 2)

		# Vẽ phần thân nến (body)
		var body_color = Color(0, 1, 0) if close_price > open_price else Color(1, 0, 0)  # Xanh nếu giá đóng cửa cao hơn giá mở cửa, đỏ nếu ngược lại
		draw_rect(Rect2(Vector2(x_pos, 250 - y_pos_body_top), Vector2(bar_width, body_height)), body_color)

	# Vẽ trục X
	draw_line(Vector2(10, 250), Vector2(10 + (bar_width + 10) * data_points.size(), 250), Color(0, 0, 0), 2)
	# Vẽ trục Y
	draw_line(Vector2(10, 50), Vector2(10, 250), Color(0, 0, 0), 2)

func _ready():
	print("Candlestick chart loaded")
	queue_redraw()  # Gọi queue_redraw để vẽ lại
