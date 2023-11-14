extends Marker3D

func _process(delta):
	#self.rotate_y(delta)
	
	self.scale = Vector3(
		zoomLevel,
		zoomLevel,
		zoomLevel
	)
	
	var moveInput : Vector2 = Input.get_vector("left", "right", "up", "down")
	
	self.rotate_y(moveInput.x * delta)
	self.rotate_x(moveInput.y * delta)

var zoomLevel = 1.0

func _input(event):
	if Input.is_action_just_pressed("scroll_up"):
		zoomLevel -= 0.05
	if Input.is_action_just_pressed("scroll_down"):
		zoomLevel += 0.05
		
