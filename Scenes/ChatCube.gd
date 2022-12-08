extends MeshInstance

var x_rotation_speed = 0.4
var y_rotation_speed = 0.6
var z_rotation_speed = 0.2

func _process(delta):
	rotation.x += delta * x_rotation_speed
	rotation.y += delta * y_rotation_speed
	rotation.z += delta * z_rotation_speed
