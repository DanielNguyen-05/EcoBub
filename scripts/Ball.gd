extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FALL_HEIGHT = 400  # Vị trí y cố định để dừng lại
const FALL_TIME = 2.0    # Thời gian rơi xuống
const JUMP_HEIGHT = 20   # Chiều cao nhảy lên xuống
const JUMP_TIME = 0.2    # Thời gian mỗi lần nhảy lên xuống
const JUMP_COUNT = 3     # Số lần nhảy
const GRAVITY = 980      # Thêm hằng số gravity

var tween: Tween  # Khai báo biến tween với kiểu Tween
var is_falling = true
var initial_y = 0  # Lưu vị trí y ban đầu

func _ready():
	# Lưu vị trí y ban đầu
	initial_y = position.y
	
	# Tạo một Tween mới
	tween = create_tween()
	if tween == null:
		print("Failed to create tween!")
		return
		
	# Bắt đầu hiệu ứng rơi
	if is_falling:
		fall_and_jump()

func _physics_process(delta: float) -> void:
	# Chỉ xử lý input khi không trong trạng thái rơi
	if not is_falling:
		# Xử lý trọng lực
		if not is_on_floor():
			velocity.y += GRAVITY * delta

		# Xử lý nhảy
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Xử lý di chuyển ngang
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func fall_and_jump():
	# Set vị trí đích là y = 492.75
	var target_position = Vector2(position.x, FALL_HEIGHT)
	
	# Tạo tween để rơi xuống
	tween.tween_property(self, "position", target_position, FALL_TIME)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	
	# Kết nối tín hiệu hoàn thành
	tween.finished.connect(_on_fall_complete)

func _on_fall_complete():
	# Đánh dấu đã kết thúc rơi
	is_falling = true
	
	# Tạo tween mới cho hiệu ứng nhảy
	tween = create_tween()
	
	# Thực hiện nhảy lên xuống
	for i in range(JUMP_COUNT):
		var jump_time_offset = i * (JUMP_TIME * 2)
		
		# Nhảy lên
		tween.tween_property(self, "position:y", 
			FALL_HEIGHT - JUMP_HEIGHT, JUMP_TIME)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)\
			.set_delay(jump_time_offset)
			
		# Rơi xuống
		tween.tween_property(self, "position:y", 
			FALL_HEIGHT, JUMP_TIME)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN)
