extends Spatial

# COLLISIONS DU JOUEUR
const collision_scene = preload("res://SCENES/ENTITIES/PLAYER/Player_Collision.tscn")


var look_rot = Vector3(0,0,0)
var sensitivity = 0.01

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_collision()
	
func _physics_process(delta):
	rotation_degrees.y = look_rot.y * sensitivity
	
	translate(Vector3(0,0,-5) * delta)
	
func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= event.relative.x
		


func add_branch():
	
	
	get_tree().create_timer(rand_range(1,4)).connect("timeout",self,"add_collision")


func add_collision():
	var new_collision = collision_scene.instance()
	CollisionManager.add_child(new_collision)
	new_collision.global_translation = $RootsSpawn/Col/Particles.global_translation
	get_tree().create_timer(0.5).connect("timeout",self,"add_collision")
	print("COLLISION ADDED")






