extends Node2D

# Chart data and dimensions
var data_points: Array = []
var view_offset: float = 0
var screen_width: float
var screen_height: float
var chart_top: float
var chart_height: float
var chart_width: float
var chart_left: float

# Candlestick properties
const BAR_WIDTH_BASE: float = 30.0
const BAR_SPACING_BASE: float = 8.0
var bar_width: float
var bar_spacing: float
var scale_factor: float

# Visual settings
const OFFSET: float = 50.0
const CHART_WIDTH_RATIO: float = 0.45
const CHART_HEIGHT_RATIO: float = 0.45
const MIN_PRICE: float = 100.0
const MAX_PRICE: float = 300.0
const WICK_THICKNESS: float = 2.0

# Date tracking
var start_date: Dictionary = {
	"year": 2025,
	"month": 1,
	"day": 1
}

# Font resource
var font: Font

# Kiểm tra năm nhuận
func is_leap_year(year: int) -> bool:
	return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)

# Lấy số ngày trong tháng
func get_days_in_month(month: int, year: int) -> int:
	match month:
		2:  # Tháng 2
			return 29 if is_leap_year(year) else 28
		4, 6, 9, 11:  # Các tháng 30 ngày
			return 30
		1, 3, 5, 7, 8, 10, 12:  # Các tháng 31 ngày
			return 31
		_:  # Tháng không hợp lệ
			return 0

# Kiểm tra ngày tháng năm có hợp lệ
func is_valid_date(date: Dictionary) -> bool:
	# Kiểm tra năm
	if date.year < 1:
		return false
		
	# Kiểm tra tháng
	if date.month < 1 or date.month > 12:
		return false
		
	# Lấy số ngày tối đa của tháng
	var max_days = get_days_in_month(date.month, date.year)
	
	# Kiểm tra ngày
	if date.day < 1 or date.day > max_days:
		return false
		
	return true

# Hàm xử lý ngày tăng lên khi vượt quá số ngày trong tháng
func normalize_date(date: Dictionary) -> Dictionary:
	while true:
		var days_in_month = get_days_in_month(date.month, date.year)
		
		# Nếu số ngày vẫn trong giới hạn của tháng hiện tại
		if date.day <= days_in_month:
			break
			
		# Trừ số ngày của tháng hiện tại và tăng tháng lên
		date.day -= days_in_month
		date.month += 1
		
		# Nếu tháng vượt quá 12, tăng năm lên
		if date.month > 12:
			date.month = 1
			date.year += 1
	
	return date

func _ready() -> void:
	randomize()
	_initialize_font()
	_setup_chart_dimensions()
	generate_initial_data()
	queue_redraw()
	hide()

func _initialize_font() -> void:
	font = load("res://assets/Fonts/vhs_gothic/vhs-gothic.ttf")
	if !font:
		push_error("Failed to load font")

func _setup_chart_dimensions() -> void:
	var viewport_size = get_viewport().size
	screen_width = viewport_size.x
	screen_height = viewport_size.y
	
	# Calculate chart dimensions
	chart_width = screen_width * CHART_WIDTH_RATIO
	chart_height = screen_height * CHART_HEIGHT_RATIO
	chart_top = (screen_height - chart_height) / 2 + 110
	chart_left = (screen_width - chart_width) / 2 - 300
	
	# Calculate scaling
	scale_factor = chart_height / 200.0
	bar_width = BAR_WIDTH_BASE * scale_factor
	bar_spacing = BAR_SPACING_BASE * scale_factor

func generate_initial_data() -> void:
	var initial_count = ceil(chart_width / (bar_width + bar_spacing)) + 5
	for _i in range(initial_count):
		data_points.append(generate_random_candlestick())

func generate_random_candlestick() -> Dictionary:
	var open_price = randf_range(MIN_PRICE, MAX_PRICE)
	var close_price = randf_range(MIN_PRICE, MAX_PRICE)
	var high_price = max(open_price, close_price) + randf_range(0, 20)
	var low_price = min(open_price, close_price) - randf_range(0, 20)
	
	return {
		"open": open_price,
		"close": close_price,
		"high": high_price,
		"low": low_price
	}

func _draw() -> void:
	if data_points.size() == 0:
		return
		
	for i in range(data_points.size()):
		_draw_candlestick(i)

func _draw_candlestick(index: int) -> void:
	var data = data_points[index]
	var x_pos = chart_left + index * (bar_width + bar_spacing) - view_offset
	
	# Skip if outside visible area
	if x_pos + bar_width < 130 or x_pos > chart_left + chart_width:
		return
	
	# Calculate Y positions
	var y_positions = _calculate_y_positions(data)
	
	# Draw candlestick components
	_draw_wicks(x_pos, y_positions)
	_draw_body(x_pos, y_positions, data["close"] > data["open"])
	_draw_date_label(x_pos, index)

func _calculate_y_positions(data: Dictionary) -> Dictionary:
	return {
		"high": chart_top + chart_height - (data["high"] * scale_factor),
		"low": chart_top + chart_height - (data["low"] * scale_factor),
		"open": chart_top + chart_height - (data["open"] * scale_factor),
		"close": chart_top + chart_height - (data["close"] * scale_factor)
	}

func _draw_wicks(x_pos: float, y_pos: Dictionary) -> void:
	var center_x = x_pos + bar_width / 2
	var min_y = min(y_pos["open"], y_pos["close"])
	var max_y = max(y_pos["open"], y_pos["close"])
	
	# Upper wick
	draw_line(
		Vector2(center_x, y_pos["high"]),
		Vector2(center_x, min_y),
		Color.WHITE,
		WICK_THICKNESS
	)
	
	# Lower wick
	draw_line(
		Vector2(center_x, max_y),
		Vector2(center_x, y_pos["low"]),
		Color.WHITE,
		WICK_THICKNESS
	)

func _draw_body(x_pos: float, y_pos: Dictionary, is_bullish: bool) -> void:
	var body_color = Color.GREEN if is_bullish else Color.RED
	draw_rect(
		Rect2(
			Vector2(x_pos, min(y_pos["open"], y_pos["close"])),
			Vector2(bar_width, abs(y_pos["open"] - y_pos["close"]))
		),
		body_color
	)

func _draw_date_label(x_pos: float, index: int) -> void:
	var date_str = get_date_string(start_date, index)
	var label_pos = Vector2(
		x_pos + bar_width / 2 - 32,
		chart_top + chart_height - 200
	)
	# Corrected parameter order for draw_string
	draw_string(
		font,
		label_pos,
		date_str,
		HORIZONTAL_ALIGNMENT_CENTER,  # Use the correct constant
	)

func get_date_string(base_date: Dictionary, index: int) -> String:
	var date = base_date.duplicate()
	date.day += index
	date = normalize_date(date) # Chuẩn hóa ngày tháng
	return "%02d/%02d" % [date.day, date.month]


func _on_next_pressed() -> void:
	view_offset += bar_width + bar_spacing
	
	# Generate new data if needed
	if view_offset > (data_points.size() - 1) * (bar_width + bar_spacing) - chart_width:
		data_points.append(generate_random_candlestick())
	
	queue_redraw()


func _on_stock_info_dropdown_item_selected(index: int) -> void:
	if index == 0:
		show()
	else:
		hide()
