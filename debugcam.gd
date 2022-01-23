extends Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	translate(Vector3(10,10,10))

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * 0.1))
		rotate_x(deg2rad(-event.relative.y * 0.1))
		rotation.x = clamp(rotation.x, deg2rad(-89), deg2rad(89))
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _process(delta):
	var direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var h_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	var velocity = direction * 7
	translate(velocity)
