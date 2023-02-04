extends Spatial

var look_rot = Vector3.ZERO
var sensitivity = 0.01

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	rotation_degrees.y = look_rot.y * sensitivity
	translate(Vector3(0,0,-5) * delta)
	
func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= event.relative.x
