extends KinematicBody

var velocity = Vector3.ZERO
var speed = 15.0

var minCameraAngle = -90.0
var maxCameraAngle = 90.0
var cameraSensitivity = 10.0
var mouseDelta = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  
	
func _physics_process(_delta):
	velocity.x = 0
	velocity.z = 0
  
	var input = Vector2()
  
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	input = input.normalized()
  
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	var relativeDir = (forward * input.y + right * input.x)
  
	velocity.x = relativeDir.x * speed
	velocity.z = relativeDir.z * speed
	
	velocity = move_and_slide(velocity, Vector3.UP)

func _process(delta):
	$Camera.rotation_degrees.x -= mouseDelta.y * cameraSensitivity * delta
	$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, minCameraAngle, maxCameraAngle)
	rotation_degrees.y -= mouseDelta.x * cameraSensitivity * delta
	mouseDelta = Vector2()

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
