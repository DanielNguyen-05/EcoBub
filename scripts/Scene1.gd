extends Node2D

var data_points = []  # Array to store candlestick data
var bar_width = 30
var bar_spacing = 10
var view_offset = 0  # Track camera position for generating new candlesticks
var screen_width  # Width of the screen (calculated at runtime)
var screen_height
var chart_top  # Top position of the chart
var chart_height  # Height of the chart
var chart_width  # Width of the chart
var scale_factor  # Scale factor for shrinking the chart
var offset = 1000

func _ready():
	randomize()  # Ensure randomness for generated data

	# Get the dimensions of the screen
	screen_width = get_viewport().size.x + 50
	screen_height = get_viewport().size.y + 50

	# Set chart dimensions (1/4 of the screen)
	chart_width = screen_width / 12
	chart_height = screen_height / 12
	chart_top = 10  # Small padding from the top
	scale_factor = chart_height / 200.0  # Scale to fit the chart into 1/4 height

	# Adjust bar width and spacing according to scale factor
	bar_width *= scale_factor
	bar_spacing *= scale_factor

	# Generate initial candlestick data
	generate_initial_data()
	queue_redraw()  # Trigger the draw function

func generate_initial_data():
	# Generate enough candlesticks to fill the initial chart width
	var initial_count = ceil(chart_width / (bar_width + bar_spacing)) + 5
	for i in range(initial_count):
		data_points.append(generate_random_candlestick())

func generate_random_candlestick():
	# Generate random candlestick data
	var open_price = randi() % 200 + 100
	var close_price = randi() % 200 + 100
	var high_price = max(open_price, close_price) + randi() % 20
	var low_price = min(open_price, close_price) - randi() % 20
	return {"open": open_price, "close": close_price, "high": high_price, "low": low_price}

func _draw():
	# Draw candlesticks
	for i in range(data_points.size()):
		var data = data_points[i]
		var open_price = data["open"]
		var close_price = data["close"]
		var high_price = data["high"]
		var low_price = data["low"]

		# Calculate candlestick positions relative to camera
		var x_pos = i * (bar_width + bar_spacing) - view_offset
		if x_pos + bar_width < 0:  # Skip drawing off-screen to the left
			continue
		if x_pos > chart_width:  # Stop drawing if beyond the right edge
			break

		# Scale prices to fit the chart height
		var y_high = chart_top + chart_height - (high_price * scale_factor)
		var y_low = chart_top + chart_height - (low_price * scale_factor)
		var y_open = chart_top + chart_height - (open_price * scale_factor)
		var y_close = chart_top + chart_height - (close_price * scale_factor)

		# Draw upper wick
		draw_line(Vector2(x_pos + bar_width / 2, y_high), Vector2(x_pos + bar_width / 2, min(y_open, y_close)), Color(0, 0, 0), 2)

		# Draw lower wick
		draw_line(Vector2(x_pos + bar_width / 2, y_low), Vector2(x_pos + bar_width / 2, max(y_open, y_close)), Color(0, 0, 0), 2)

		# Draw body
		var body_color = Color(0, 1, 0) if close_price > open_price else Color(1, 0, 0)
		draw_rect(Rect2(Vector2(x_pos, min(y_open, y_close)), Vector2(bar_width, abs(y_open - y_close))), body_color)

	# Draw chart border
	draw_line(Vector2(screen_width - chart_width + offset, chart_top), Vector2(screen_width + offset, chart_top), Color(0, 0, 0), 2)  # Top border
	draw_line(Vector2(screen_width - chart_width + offset, chart_top + chart_height), Vector2(screen_width + offset, chart_top + chart_height), Color(0, 0, 0), 2)  # Bottom border
	draw_line(Vector2(screen_width - chart_width + offset, chart_top), Vector2(screen_width - chart_width + offset, chart_top + chart_height), Color(0, 0, 0), 2)  # Left border
	draw_line(Vector2(screen_width + offset, chart_top), Vector2(screen_width + offset, chart_top + chart_height), Color(0, 0, 0), 2)  # Right border

func _on_button_pressed() -> void:
	# Simulate camera movement (rightward for example)
	view_offset += 95 * 0.2  # Adjust speed here
	if view_offset > (data_points.size() - 1) * (bar_width + bar_spacing) - chart_width:
		# Generate more candlesticks as camera approaches the edge
		data_points.append(generate_random_candlestick())
	queue_redraw()  # Continuously redraw as the camera moves
