extends Spatial

# COLLISIONS DU JOUEUR
const collision_scene = preload("res://SCENES/ENTITIES/PLAYER/Player_Collision.tscn")

var last_collision = null

var look_rot = Vector3(0,0,0)
var sensitivity = 0.01
var motion_y = 0
var canMove = false

var velocity = Vector3.ZERO

onready var raycast = $RootsSpawn/Col/Particles/RayCast
onready var particles = $RootsSpawn/Col/Particles
onready var ground_level = global_translation
onready var roots = $RootsSpawn

func _ready():
	canMove = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_collision()
	roots.connect("body_entered",self,"_on_collision")

func _physics_process(delta):
	rotation_degrees.y = look_rot.y * sensitivity
	
	if canMove:
		velocity.z = -5
	
	
	raycast.force_raycast_update()
	if raycast.is_colliding():
		if ( raycast.get_collider().is_in_group("collision_joueur") || raycast.get_collider().is_in_group("collision_obstacles") ) && canMove:
			canMove = false
			Transition.change_scene_to(LevelManager.get_level($"..".next_level - 1))
			
		if canMove && raycast.get_collider().is_in_group("collision_victoire"):
			canMove = false
			Transition.change_scene_to(LevelManager.get_level($"..".next_level))
#			velocity.y = range_lerp(raycast.global_translation.distance_to(raycast.get_collider().global_translation),0,8,5,0)
#	else:
#		velocity.y = ground_level.y - global_translation.y
	

	
	translate(velocity * delta)
	
func _input(event):
	if event is InputEventMouseMotion && canMove:
		look_rot.y -= event.relative.x
		
	if canMove == false && event is InputEventKey:
		if event.scancode == KEY_SPACE:
			canMove = true
		



func _on_collision(collider:Spatial):
	if collider.is_in_group("dangereux"):
		set_physics_process(false)

func add_branch():
	get_tree().create_timer(rand_range(1,4),false).connect("timeout",self,"add_collision")


func add_collision():
	if canMove:
		var new_col = collision_scene.instance()
		CollisionManager.add_child(new_col)
		new_col.global_translation = $RootsSpawn/Col/Particles.global_translation
		if last_collision != null:
			new_col.set_last_collision(last_collision)
		last_collision = new_col
	get_tree().create_timer(0.25,false).connect("timeout",self,"add_collision")
	print("COLLISION ADDED")






